const request = require("supertest");
const app = require("../src/server");

describe("Error Handling", () => {
    test("Unknown route should return HTTP 404", async () => {
        const response = await request(app).get("/does-not-exist");

        expect(response.statusCode).toBe(404);
    });
});