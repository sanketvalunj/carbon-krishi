import { generateSubmissionHash } from "../utils/hashUtil.js";
import { storeHashOnChain } from "../services/blockchainService.js";

export async function submitCarbonData(req, res) {
  try {
    const submissionData = req.body;

    // 1. Generate hash
    const hash = generateSubmissionHash(submissionData);


    const txHash = await storeHashOnChain(hash);


    res.status(201).json({
      message: "Submission recorded and secured on blockchain",
      blockchainHash: hash,
      txHash
    });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
}
