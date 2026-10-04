const express = require("express");

const app = express();

app.get("/", (req, res) => {
    res.json({
        application: "SAP BTP DevOps Demo",
        status: "running",
        version: "1.0.0"
    });
});

app.get("/health", (req, res) => {
    res.json({
        status: "healthy"
    });
});

if (require.main === module) {
    const PORT = process.env.PORT || 3000;

    app.listen(PORT, () => {
        console.log("Server running on port " + PORT);
    });
}

module.exports = app;