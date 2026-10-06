const request = require("supertest");
const app = require("../src/server");

describe("Root Endpoint", () => {
    test("GET / should return HTTP 200", async () => {
        const response = await request(app).get("/");

        expect(response.statusCode).toBe(200);
    });

    test("GET / should return correct application name", async () => {
        const response = await request(app).get("/");

        expect(response.body.application).toBe("SAP BTP DevOps Demo");
    });

    test("GET / should return correct version", async () => {
        const response = await request(app).get("/");

        expect(response.body.version).toBe("1.0.0");
    });
});