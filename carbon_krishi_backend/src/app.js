import express from "express";

const app = express();
app.use(express.json());


app.get("/", (req, res) => {
  res.send("Carbon Krishi Backend is running");
});

// 🔹 carbon routes
import submissionRoutes from "./routes/submissionRoutes.js";
app.use("/api/carbon", submissionRoutes);


const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
