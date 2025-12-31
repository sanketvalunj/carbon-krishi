import { ethers } from "ethers";
import abi from "../../blockchain/abi/CarbonKrishiLedger.json" with { type: "json" };

// NOTE: Hardcoded only for local demo
const RPC_URL = "http://127.0.0.1:8545";
const PRIVATE_KEY =
  "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const CONTRACT_ADDRESS =
  "0x5FbDB2315678afecb367f032d93F642f64180aa3";

// Provider (ethers v5)
const provider = new ethers.providers.JsonRpcProvider(RPC_URL);

// Wallet
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

// Contract
const contract = new ethers.Contract(
  CONTRACT_ADDRESS,
  abi.abi,
  wallet
);

export async function storeHashOnChain(hash) {
  const tx = await contract.addSubmission(hash);
  await tx.wait();
  return tx.hash;
}
