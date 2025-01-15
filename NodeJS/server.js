const express = require("express");
const cors = require("cors"); // Import cors
const { exec } = require("child_process");

const app = express();
const PORT = 5000;

app.use(cors());

app.use(express.json());

app.post("/run-r-script", (req, res) => {
  const { params } = req.body;
  const command = `Rscript ./NodeJS/script.R ${params.join(" ")}`;

  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      res.status(500).json({ error: error.message });
      return;
    }
    if (stderr) {
      console.error(`Stderr: ${stderr}`);
      res.status(500).json({ error: stderr });
      return;
    }
    console.log(`Output: ${stdout}`);
    res.status(200).json({ output: stdout });
  });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
