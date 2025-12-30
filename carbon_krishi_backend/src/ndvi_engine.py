"""
AI-Driven NDVI Simulation Engine for Carbon Credit MRV System
===============================================================
This module generates realistic NDVI values for farms based on:
- Crop type and growth stage
- Seasonal variations
- Farming practices (irrigation, fertilizer)
- Geographic location

Author: Carbon Credit MRV System
Date: December 2025
"""

import random
import math
from datetime import datetime, timedelta
from typing import Dict, List, Tuple
import json

class NDVISimulator:
    """
    Generates realistic NDVI values for agricultural farms
    """
    
    # Base NDVI ranges for different crop types (min, max, optimal)
    CROP_NDVI_PROFILES = {
        "rice": {"base": 0.65, "range": (0.4, 0.85), "peak_month": 8},
        "wheat": {"base": 0.60, "range": (0.35, 0.80), "peak_month": 2},
        "sugarcane": {"base": 0.75, "range": (0.50, 0.90), "peak_month": 10},
        "cotton": {"base": 0.55, "range": (0.30, 0.75), "peak_month": 9},
        "maize": {"base": 0.58, "range": (0.35, 0.78), "peak_month": 7},
        "soybean": {"base": 0.62, "range": (0.40, 0.82), "peak_month": 8},
        "pulses": {"base": 0.50, "range": (0.30, 0.70), "peak_month": 11},
        "vegetables": {"base": 0.55, "range": (0.35, 0.75), "peak_month": 6},
        "millets": {"base": 0.52, "range": (0.32, 0.72), "peak_month": 9},
        "groundnut": {"base": 0.58, "range": (0.38, 0.78), "peak_month": 10}
    }
    
    # Season multipliers (Kharif, Rabi, Zaid for India)
    SEASON_FACTORS = {
        "kharif": 1.1,    # Monsoon season (June-October) - better growth
        "rabi": 1.0,      # Winter season (November-March)
        "zaid": 0.9,      # Summer season (March-June) - water stress
        "perennial": 1.05  # Year-round crops
    }
    
    # Practice impact multipliers
    PRACTICE_MULTIPLIERS = {
        "irrigation": {
            "drip": 1.15,
            "sprinkler": 1.10,
            "flood": 1.05,
            "rainfed": 0.90
        },
        "fertilizer": {
            "organic": 1.08,
            "balanced_chemical": 1.12,
            "excessive_chemical": 0.95,  # Can harm soil health
            "minimal": 0.92
        },
        "tillage": {
            "no_till": 1.10,
            "minimum_till": 1.05,
            "conventional": 1.00
        }
    }
    
    def __init__(self):
        """Initialize the NDVI simulator"""
        self.random_seed = None
    
    def set_seed(self, seed: int):
        """Set random seed for reproducibility"""
        self.random_seed = seed
        random.seed(seed)
    
    def _get_seasonal_factor(self, month: int, crop_type: str) -> float:
        """
        Calculate seasonal variation factor based on month and crop type
        """
        if crop_type not in self.CROP_NDVI_PROFILES:
            crop_type = "rice"  # Default
        
        peak_month = self.CROP_NDVI_PROFILES[crop_type]["peak_month"]
        
        # Calculate distance from peak month (circular)
        month_diff = min(abs(month - peak_month), 
                        12 - abs(month - peak_month))
        
        # Gaussian-like growth curve
        # Peak at 1.0, drops to 0.6 at 6 months away
        seasonal_factor = 0.6 + 0.4 * math.exp(-(month_diff ** 2) / 12)
        
        return seasonal_factor
    
    def _apply_practice_effects(self, base_ndvi: float, 
                                irrigation: str, 
                                fertilizer: str,
                                tillage: str) -> float:
        """
        Apply farming practice multipliers to base NDVI
        """
        irrigation_mult = self.PRACTICE_MULTIPLIERS["irrigation"].get(
            irrigation, 1.0
        )
        fertilizer_mult = self.PRACTICE_MULTIPLIERS["fertilizer"].get(
            fertilizer, 1.0
        )
        tillage_mult = self.PRACTICE_MULTIPLIERS["tillage"].get(
            tillage, 1.0
        )
        
        # Combined effect (multiplicative)
        adjusted_ndvi = base_ndvi * irrigation_mult * fertilizer_mult * tillage_mult
        
        # Ensure within valid NDVI range (-1 to 1, typically 0 to 0.9 for vegetation)
        return max(0.1, min(0.95, adjusted_ndvi))
    
    def _add_realistic_noise(self, ndvi: float) -> float:
        """
        Add small random variations to simulate real-world variability
        (cloud cover, soil moisture variations, etc.)
        """
        noise = random.gauss(0, 0.03)  # ±3% standard deviation
        return max(0.1, min(0.95, ndvi + noise))
    
    def calculate_ndvi(self, 
                      farm_data: Dict,
                      measurement_date: datetime = None) -> Dict:
        """
        Main method to calculate simulated NDVI for a farm
        
        Args:
            farm_data: Dictionary containing:
                - crop_type: str
                - latitude: float
                - longitude: float
                - irrigation_type: str
                - fertilizer_type: str
                - tillage_type: str
                - farm_size_hectares: float
                - planting_date: datetime (optional)
            measurement_date: Date of NDVI measurement (default: today)
        
        Returns:
            Dictionary with NDVI value and metadata
        """
        if measurement_date is None:
            measurement_date = datetime.now()
        
        # Extract farm parameters
        crop_type = farm_data.get("crop_type", "rice").lower()
        irrigation = farm_data.get("irrigation_type", "rainfed").lower()
        fertilizer = farm_data.get("fertilizer_type", "balanced_chemical").lower()
        tillage = farm_data.get("tillage_type", "conventional").lower()
        latitude = farm_data.get("latitude", 20.5937)  # Default: Central India
        
        # Get base NDVI for crop
        if crop_type not in self.CROP_NDVI_PROFILES:
            crop_type = "rice"
        
        crop_profile = self.CROP_NDVI_PROFILES[crop_type]
        base_ndvi = crop_profile["base"]
        
        # Apply seasonal factor
        month = measurement_date.month
        seasonal_factor = self._get_seasonal_factor(month, crop_type)
        seasonal_ndvi = base_ndvi * seasonal_factor
        
        # Apply farming practices
        practice_adjusted_ndvi = self._apply_practice_effects(
            seasonal_ndvi, irrigation, fertilizer, tillage
        )
        
        # Add realistic noise
        final_ndvi = self._add_realistic_noise(practice_adjusted_ndvi)
        
        # Calculate confidence score (based on data quality indicators)
        confidence = self._calculate_confidence(farm_data)
        
        # Health classification
        health_status = self._classify_vegetation_health(final_ndvi)
        
        return {
            "ndvi_value": round(final_ndvi, 3),
            "measurement_date": measurement_date.isoformat(),
            "crop_type": crop_type,
            "health_status": health_status,
            "confidence_score": confidence,
            "contributing_factors": {
                "base_ndvi": round(base_ndvi, 3),
                "seasonal_factor": round(seasonal_factor, 3),
                "irrigation_impact": irrigation,
                "fertilizer_impact": fertilizer,
                "tillage_impact": tillage
            },
            "location": {
                "latitude": latitude,
                "longitude": farm_data.get("longitude", 78.9629)
            }
        }
    
    def _classify_vegetation_health(self, ndvi: float) -> str:
        """Classify vegetation health based on NDVI value"""
        if ndvi < 0.2:
            return "bare_soil"
        elif ndvi < 0.4:
            return "sparse_vegetation"
        elif ndvi < 0.6:
            return "moderate_vegetation"
        elif ndvi < 0.75:
            return "healthy_vegetation"
        else:
            return "very_dense_vegetation"
    
    def _calculate_confidence(self, farm_data: Dict) -> float:
        """
        Calculate confidence score based on data completeness
        (In production, this would factor in satellite image quality, 
        cloud cover, etc.)
        """
        required_fields = ["crop_type", "irrigation_type", "fertilizer_type", 
                          "latitude", "longitude"]
        
        completeness = sum(1 for field in required_fields 
                          if field in farm_data and farm_data[field]) / len(required_fields)
        
        # Add small random variation
        confidence = completeness * random.uniform(0.85, 0.95)
        
        return round(confidence, 2)
    
    def generate_time_series(self, 
                            farm_data: Dict,
                            start_date: datetime,
                            end_date: datetime,
                            interval_days: int = 16) -> List[Dict]:
        """
        Generate NDVI time series (simulating satellite revisit frequency)
        Typical satellites like Sentinel-2 revisit every 5-16 days
        
        Args:
            farm_data: Farm information dictionary
            start_date: Start date for time series
            end_date: End date for time series
            interval_days: Days between measurements (default: 16)
        
        Returns:
            List of NDVI measurements with dates
        """
        time_series = []
        current_date = start_date
        
        while current_date <= end_date:
            ndvi_result = self.calculate_ndvi(farm_data, current_date)
            time_series.append(ndvi_result)
            current_date += timedelta(days=interval_days)
        
        return time_series
    
    def estimate_carbon_from_ndvi(self, ndvi_value: float, 
                                  farm_size_hectares: float) -> Dict:
        """
        Estimate carbon sequestration potential based on NDVI
        
        Simplified model:
        - Higher NDVI = more biomass = more carbon sequestration
        - Typical cropland sequesters 0.5-2 tonnes CO2/hectare/year
        
        Args:
            ndvi_value: NDVI value (0 to 1)
            farm_size_hectares: Farm size in hectares
        
        Returns:
            Carbon sequestration estimate
        """
        # Normalized NDVI to carbon factor (tonnes CO2e per hectare per year)
        # Linear relationship: NDVI 0.4 → 0.5t, NDVI 0.8 → 2t
        if ndvi_value < 0.2:
            carbon_factor = 0.1
        elif ndvi_value < 0.4:
            carbon_factor = 0.3
        else:
            carbon_factor = 0.5 + (ndvi_value - 0.4) * 3.75
        
        annual_sequestration = carbon_factor * farm_size_hectares
        
        # Monthly rate (assuming uniform distribution)
        monthly_sequestration = annual_sequestration / 12
        
        return {
            "annual_carbon_sequestration_tonnes_co2e": round(annual_sequestration, 2),
            "monthly_carbon_sequestration_tonnes_co2e": round(monthly_sequestration, 3),
            "carbon_factor_per_hectare": round(carbon_factor, 2),
            "ndvi_value": ndvi_value,
            "farm_size_hectares": farm_size_hectares
        }


# ============================================================================
# EXAMPLE USAGE & TESTING
# ============================================================================

def example_usage():
    """Demonstrate how to use the NDVI simulator"""
    
    # Initialize simulator
    simulator = NDVISimulator()
    simulator.set_seed(42)  # For reproducible results
    
    # Example farm data (as would come from Flutter app)
    farm_data = {
        "farm_id": "MH_PUNE_001",
        "farmer_name": "Ramesh Kumar",
        "crop_type": "rice",
        "farm_size_hectares": 2.5,
        "latitude": 18.5204,
        "longitude": 73.8567,
        "irrigation_type": "drip",
        "fertilizer_type": "organic",
        "tillage_type": "no_till",
        "planting_date": datetime(2024, 6, 15)
    }
    
    print("=" * 70)
    print("NDVI SIMULATION FOR CARBON CREDIT MRV SYSTEM")
    print("=" * 70)
    
    # 1. Single NDVI measurement
    print("\n1. CURRENT NDVI MEASUREMENT:")
    print("-" * 70)
    current_ndvi = simulator.calculate_ndvi(farm_data)
    print(json.dumps(current_ndvi, indent=2))
    
    # 2. NDVI time series (6 months)
    print("\n2. NDVI TIME SERIES (Last 6 months, 16-day intervals):")
    print("-" * 70)
    end_date = datetime.now()
    start_date = end_date - timedelta(days=180)
    
    time_series = simulator.generate_time_series(
        farm_data, start_date, end_date, interval_days=16
    )
    
    print(f"Total measurements: {len(time_series)}")
    print("\nSample measurements:")
    for i, measurement in enumerate(time_series[:5]):  # Show first 5
        print(f"  {i+1}. Date: {measurement['measurement_date'][:10]} | "
              f"NDVI: {measurement['ndvi_value']} | "
              f"Health: {measurement['health_status']}")
    
    # 3. Carbon estimation from NDVI
    print("\n3. CARBON SEQUESTRATION ESTIMATE:")
    print("-" * 70)
    carbon_estimate = simulator.estimate_carbon_from_ndvi(
        current_ndvi["ndvi_value"],
        farm_data["farm_size_hectares"]
    )
    print(json.dumps(carbon_estimate, indent=2))
    
    # 4. Compare different farming practices
    print("\n4. IMPACT OF FARMING PRACTICES:")
    print("-" * 70)
    
    scenarios = [
        {"name": "Current (Drip + Organic + No-till)", 
         "irrigation": "drip", "fertilizer": "organic", "tillage": "no_till"},
        {"name": "Rainfed + Minimal fertilizer", 
         "irrigation": "rainfed", "fertilizer": "minimal", "tillage": "conventional"},
        {"name": "Flood + Excessive chemical", 
         "irrigation": "flood", "fertilizer": "excessive_chemical", "tillage": "conventional"}
    ]
    
    for scenario in scenarios:
        test_farm = farm_data.copy()
        test_farm["irrigation_type"] = scenario["irrigation"]
        test_farm["fertilizer_type"] = scenario["fertilizer"]
        test_farm["tillage_type"] = scenario["tillage"]
        
        result = simulator.calculate_ndvi(test_farm)
        print(f"\n{scenario['name']}:")
        print(f"  NDVI: {result['ndvi_value']} | Health: {result['health_status']}")
    
    # 5. Generate data for multiple farms
    print("\n5. MULTI-FARM SIMULATION (Village-level):")
    print("-" * 70)
    
    crops = ["rice", "wheat", "cotton", "sugarcane"]
    village_data = []
    
    for i, crop in enumerate(crops):
        farm = farm_data.copy()
        farm["farm_id"] = f"MH_PUNE_{i+1:03d}"
        farm["crop_type"] = crop
        farm["farm_size_hectares"] = random.uniform(1.0, 5.0)
        
        ndvi_result = simulator.calculate_ndvi(farm)
        carbon_result = simulator.estimate_carbon_from_ndvi(
            ndvi_result["ndvi_value"],
            farm["farm_size_hectares"]
        )
        
        village_data.append({
            "farm_id": farm["farm_id"],
            "crop": crop,
            "ndvi": ndvi_result["ndvi_value"],
            "annual_carbon_tonnes": carbon_result["annual_carbon_sequestration_tonnes_co2e"]
        })
    
    total_carbon = sum(f["annual_carbon_tonnes"] for f in village_data)
    
    print(f"Village-level Summary:")
    print(f"  Total farms: {len(village_data)}")
    print(f"  Total annual carbon sequestration: {total_carbon:.2f} tonnes CO2e")
    print(f"\n  Per-farm breakdown:")
    for farm in village_data:
        print(f"    {farm['farm_id']} | {farm['crop']:10s} | "
              f"NDVI: {farm['ndvi']:.3f} | Carbon: {farm['annual_carbon_tonnes']:.2f}t")
    
    print("\n" + "=" * 70)
    print("SIMULATION COMPLETE")
    print("=" * 70)


if __name__ == "__main__":
    example_usage()