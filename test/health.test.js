const request = require("supertest");
const app = require("../src/server");

describe("Health Check", () => {
    test("GET /health should return HTTP 200", async () => {
        const response = await request(app).get("/health");

        expect(response.statusCode).toBe(200);
    });

    test("GET /health should return healthy status", async () => {
        const response = await request(app).get("/health");

        expect(response.body).toEqual({
            status: "healthy"
        });
    });
});