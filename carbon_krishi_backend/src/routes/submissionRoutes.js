import express from "express";
import { submitCarbonData } from "../controllers/submissionController.js";

const router = express.Router();

router.post("/submit", submitCarbonData);

export default router;
