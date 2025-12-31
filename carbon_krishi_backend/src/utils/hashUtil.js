import crypto from "crypto";

export function generateSubmissionHash(submissionData) {
  return crypto
    .createHash("sha256")
    .update(JSON.stringify(submissionData))
    .digest("hex");
}
