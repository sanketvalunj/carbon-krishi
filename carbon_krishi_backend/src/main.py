"""
CarbonKrishi Backend API
FastAPI server for carbon credit MRV platform
Team: NexAi
"""

from fastapi import FastAPI, HTTPException, Depends, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from uuid import uuid4
import uvicorn

# Initialize FastAPI app
app = FastAPI(
    title="CarbonKrishi API",
    description="AI-Driven Carbon Credit MRV Platform for Small Farmers",
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change to specific origins in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================================================
# DATA MODELS (Pydantic)
# ============================================================================

class FarmerRegistration(BaseModel):
    name: str = Field(..., min_length=2, max_length=255)
    phone: str = Field(..., regex=r"^\d{10}$")
    village: str
    farm_size: float = Field(..., gt=0)

class FarmerResponse(BaseModel):
    id: str
    name: str
    phone: str
    village: str
    created_at: datetime

class FarmData(BaseModel):
    farm_size: float
    crop_type: str
    season: str
    fertilizer_type: str
    fertilizer_quantity: float
    tilling_method: str
    irrigation_type: str
    trees_planted: int
    crop_residue_method: str
    use_compost: bool
    location: Optional[dict] = None

class CarbonCalculationRequest(BaseModel):
    farm_id: str
    farm_data: FarmData

class CarbonScore(BaseModel):
    total_co2e: float
    trees_contribution: float
    soil_contribution: float
    emission_reduction: float
    breakdown: dict

class CarbonCredit(BaseModel):
    id: str
    farm_id: str
    credits: int
    co2e_tonnes: float
    source: str
    blockchain_hash: str
    status: str
    issued_at: datetime

class Recommendation(BaseModel):
    id: str
    title: str
    description: str
    impact: str
    category: str

# ============================================================================
# IN-MEMORY DATABASE (Replace with PostgreSQL/MongoDB)
# ============================================================================

farmers_db = {}
farms_db = {}
credits_db = {}


# ============================================================================
# CARBON CALCULATION ENGINE
# ============================================================================

class CarbonCalculator:
    """
    Hybrid AI + Rule-based Carbon Estimation Engine
    """
    
    # Carbon sequestration coefficients (tonnes CO2e per unit)
    CROP_COEFFICIENTS = {
        "Rice": 0.5,
        "Wheat": 0.4,
        "Sugarcane": 0.8,
        "Cotton": 0.3,
        "Maize": 0.45,
        "Vegetables": 0.35
    }
    
    TREE_COEFFICIENT = 0.02  # tonnes CO2e per tree per year
    
    # Emission factors
    FERTILIZER_EMISSIONS = {
        "Organic": 0.1,
        "Chemical": 0.8,
        "Mixed": 0.4,
        "None": 0.0
    }
    
    TILLING_EMISSIONS = {
        "No-Till": -0.5,  # Negative = sequestration
        "Reduced Till": -0.2,
        "Conventional": 0.3
    }
    
    IRRIGATION_EMISSIONS = {
        "Solar": 0.0,
        "Electric": 0.3,
        "Diesel": 0.8
    }
    
    @classmethod
    def calculate(cls, farm_data: FarmData) -> CarbonScore:
        """
        Calculate carbon sequestration and emission reductions
        """
        # 1. Trees contribution
        trees_co2e = farm_data.trees_planted * cls.TREE_COEFFICIENT
        
        # 2. Soil practices (crop-based)
        crop_coef = cls.CROP_COEFFICIENTS.get(farm_data.crop_type, 0.4)
        soil_co2e = farm_data.farm_size * crop_coef
        
        # Add tilling bonus/penalty
        tilling_impact = cls.TILLING_EMISSIONS.get(farm_data.tilling_method, 0)
        soil_co2e += (farm_data.farm_size * tilling_impact)
        
        # 3. Emission reductions
        # Fertilizer
        fert_emissions = farm_data.fertilizer_quantity * cls.FERTILIZER_EMISSIONS.get(
            farm_data.fertilizer_type, 0.5
        )
        
        # Irrigation
        irrigation_emissions = farm_data.farm_size * cls.IRRIGATION_EMISSIONS.get(
            farm_data.irrigation_type, 0.3
        )
        
        # Baseline emissions (what conventional farming would emit)
        baseline_emissions = (
            farm_data.fertilizer_quantity * 0.8 +  # Chemical baseline
            farm_data.farm_size * 0.8  # Diesel irrigation baseline
        )
        
        actual_emissions = fert_emissions + irrigation_emissions
        emission_reduction = max(0, baseline_emissions - actual_emissions)
        
        # Total net CO2e
        total_co2e = trees_co2e + soil_co2e + emission_reduction
        
        return CarbonScore(
            total_co2e=round(total_co2e, 2),
            trees_contribution=round(trees_co2e, 2),
            soil_contribution=round(soil_co2e, 2),
            emission_reduction=round(emission_reduction, 2),
            breakdown={
                "trees": {
                    "count": farm_data.trees_planted,
                    "co2e_per_tree": cls.TREE_COEFFICIENT,
                    "total": round(trees_co2e, 2)
                },
                "soil": {
                    "crop_type": farm_data.crop_type,
                    "tilling_method": farm_data.tilling_method,
                    "total": round(soil_co2e, 2)
                },
                "emissions": {
                    "baseline": round(baseline_emissions, 2),
                    "actual": round(actual_emissions, 2),
                    "reduction": round(emission_reduction, 2)
                }
            }
        )

# ============================================================================
# AI RECOMMENDATION ENGINE
# ============================================================================

class AIRecommender:
    """
    Generate personalized recommendations based on farm data
    """
    
    @staticmethod
    def generate_recommendations(farm_data: FarmData) -> List[Recommendation]:
        recommendations = []
        
        # Recommendation 1: Tree planting
        if farm_data.trees_planted < 50:
            trees_needed = 50 - farm_data.trees_planted
            impact = trees_needed * 0.02
            recommendations.append(Recommendation(
                id=str(uuid4()),
                title="Plant More Trees",
                description=f"Plant {trees_needed} more trees to reach optimal carbon sequestration",
                impact=f"+{impact:.1f} tonnes CO2e/year",
                category="sequestration"
            ))
        
        # Recommendation 2: No-till farming
        if farm_data.tilling_method != "No-Till":
            recommendations.append(Recommendation(
                id=str(uuid4()),
                title="Switch to No-Till Farming",
                description="Improve soil carbon storage and reduce emissions by 40%",
                impact="+0.5 tonnes CO2e/acre/year",
                category="practices"
            ))
        
        # Recommendation 3: Solar irrigation
        if farm_data.irrigation_type != "Solar":
            recommendations.append(Recommendation(
                id=str(uuid4()),
                title="Install Solar Irrigation",
                description="Eliminate diesel emissions completely with solar pumps",
                impact=f"+{farm_data.farm_size * 0.8:.1f} tonnes CO2e/year",
                category="energy"
            ))
        
        # Recommendation 4: Organic fertilizer
        if farm_data.fertilizer_type == "Chemical":
            recommendations.append(Recommendation(
                id=str(uuid4()),
                title="Switch to Organic Fertilizer",
                description="Reduce fertilizer emissions by 70% with organic alternatives",
                impact=f"+{farm_data.fertilizer_quantity * 0.7:.1f} tonnes CO2e/year",
                category="inputs"
            ))
        
        return recommendations

# ============================================================================
# API ENDPOINTS
# ============================================================================

@app.get("/")
def root():
    return {
        "message": "CarbonKrishi API by NexAi",
        "version": "1.0.0",
        "docs": "/api/docs"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy", "timestamp": datetime.now()}

# ============================================================================
# AUTHENTICATION ENDPOINTS
# ============================================================================

@app.post("/api/auth/register", response_model=FarmerResponse)
def register_farmer(farmer: FarmerRegistration):
    """
    Register a new farmer
    """
    # Check if phone already exists
    if any(f["phone"] == farmer.phone for f in farmers_db.values()):
        raise HTTPException(status_code=400, detail="Phone number already registered")
    
    farmer_id = str(uuid4())
    farmer_data = {
        "id": farmer_id,
        "name": farmer.name,
        "phone": farmer.phone,
        "village": farmer.village,
        "farm_size": farmer.farm_size,
        "created_at": datetime.now()
    }
    
    farmers_db[farmer_id] = farmer_data
    
    return FarmerResponse(**farmer_data)

@app.get("/api/farmers/{farmer_id}", response_model=FarmerResponse)
def get_farmer(farmer_id: str):
    """
    Get farmer details
    """
    if farmer_id not in farmers_db:
        raise HTTPException(status_code=404, detail="Farmer not found")
    
    return FarmerResponse(**farmers_db[farmer_id])

# ============================================================================
# FARM DATA ENDPOINTS
# ============================================================================

@app.post("/api/farms/data")
def submit_farm_data(data: FarmData):
    """
    Submit farm data for a new entry
    """
    farm_id = str(uuid4())
    farms_db[farm_id] = {
        "id": farm_id,
        "data": data.dict(),
        "created_at": datetime.now()
    }
    
    return {
        "success": True,
        "farm_id": farm_id,
        "message": "Farm data saved successfully"
    }

# ============================================================================
# CARBON CALCULATION ENDPOINTS
# ============================================================================

@app.post("/api/carbon/calculate", response_model=CarbonScore)
def calculate_carbon(request: CarbonCalculationRequest):
    """
    Calculate carbon impact from farm data
    """
    score = CarbonCalculator.calculate(request.farm_data)
    return score

@app.get("/api/carbon/score/{farm_id}")
def get_carbon_score(farm_id: str):
    """
    Get carbon score for a farm
    """
    if farm_id not in farms_db:
        raise HTTPException(status_code=404, detail="Farm not found")
    
    farm_data = FarmData(**farms_db[farm_id]["data"])
    score = CarbonCalculator.calculate(farm_data)
    
    return score

# ============================================================================
# CARBON CREDITS ENDPOINTS
# ============================================================================

@app.post("/api/credits/issue")
def issue_credits(farm_id: str):
    """
    Issue carbon credits based on calculated score
    """
    if farm_id not in farms_db:
        raise HTTPException(status_code=404, detail="Farm not found")
    
    # Calculate carbon score
    farm_data = FarmData(**farms_db[farm_id]["data"])
    score = CarbonCalculator.calculate(farm_data)
    
    # Convert CO2e to credits (1 credit = 0.1 tonne CO2e)
    credits = int(score.total_co2e * 10)
    
    # Generate blockchain hash (mock)
    blockchain_hash = f"0x{uuid4().hex[:32]}"
    
    credit_id = str(uuid4())
    credit = {
        "id": credit_id,
        "farm_id": farm_id,
        "credits": credits,
        "co2e_tonnes": score.total_co2e,
        "source": "AI-Estimated",
        "blockchain_hash": blockchain_hash,
        "status": "Pre-MRV",
        "issued_at": datetime.now()
    }
    
    credits_db[credit_id] = credit
    
    return CarbonCredit(**credit)

@app.get("/api/credits/{farmer_id}")
def get_credits(farmer_id: str):
    """
    Get all credits for a farmer
    """
    # Mock data - replace with database query
    farmer_credits = [
        credit for credit in credits_db.values()
        if credit.get("farmer_id") == farmer_id
    ]
    
    return {
        "total_credits": sum(c["credits"] for c in farmer_credits),
        "transactions": farmer_credits
    }

# ============================================================================
# AI RECOMMENDATIONS ENDPOINTS
# ============================================================================

@app.get("/api/recommendations/{farm_id}")
def get_recommendations(farm_id: str):
    """
    Get personalized AI recommendations
    """
    if farm_id not in farms_db:
        raise HTTPException(status_code=404, detail="Farm not found")
    
    farm_data = FarmData(**farms_db[farm_id]["data"])
    recommendations = AIRecommender.generate_recommendations(farm_data)
    
    return {
        "farm_id": farm_id,
        "recommendations": recommendations
    }

# ============================================================================
# SATELLITE DATA ENDPOINTS (MOCK)
# ============================================================================

@app.get("/api/satellite/ndvi")
def get_ndvi(latitude: float, longitude: float, date: Optional[str] = None):
    """
    Get NDVI data for location (mock implementation)
    """
    # Mock NDVI data - replace with Google Earth Engine API
    import random
    
    return {
        "location": {
            "latitude": latitude,
            "longitude": longitude
        },
        "date": date or datetime.now().isoformat(),
        "ndvi": round(random.uniform(0.3, 0.8), 2),
        "vegetation_health": "Good",
        "source": "Mock Data (Replace with GEE)"
    }

# ============================================================================
# PHOTO UPLOAD ENDPOINTS
# ============================================================================

@app.post("/api/photos/upload")
async def upload_photo(
    farm_id: str,
    photo_type: str,
    file: UploadFile = File(...)
):
    """
    Upload geotagged photo
    """
    # In production, upload to S3/Cloud Storage
    photo_id = str(uuid4())
    
    return {
        "success": True,
        "photo_id": photo_id,
        "farm_id": farm_id,
        "photo_type": photo_type,
        "message": "Photo uploaded successfully"
    }

# ============================================================================
# RUN SERVER
# ============================================================================

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )