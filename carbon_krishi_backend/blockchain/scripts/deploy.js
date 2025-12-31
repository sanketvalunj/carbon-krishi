async function main() {
    const CarbonKrishiLedger = await ethers.getContractFactory(
      "CarbonKrishiLedger"
    );
  
    const contract = await CarbonKrishiLedger.deploy();
    await contract.deployed();
  
    console.log("✅ CarbonKrishiLedger deployed to:", contract.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  