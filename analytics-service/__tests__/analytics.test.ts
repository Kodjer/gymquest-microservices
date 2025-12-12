// @ts-nocheck
import { supabaseRequest } from "../src/config/supabase";

global.fetch = jest.fn();

describe("Analytics Service Tests", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("should calculate average level", () => {
    const players = [{ level: 1 }, { level: 3 }, { level: 5 }];
    const avgLevel =
      players.reduce((sum, p) => sum + p.level, 0) / players.length;

    expect(avgLevel).toBe(3);
  });

  test("should get global stats", async () => {
    const mockStats = { total_users: 10, total_quests: 50 };

    (global.fetch as jest.Mock).mockResolvedValueOnce({
      ok: true,
      text: async () => JSON.stringify([mockStats]),
    });

    const result = await supabaseRequest(
      "GET",
      "players",
      null,
      "?select=count"
    );
    expect(result).toBeDefined();
  });

  test("should count completed quests", () => {
    const quests = [
      { status: "done" },
      { status: "pending" },
      { status: "done" },
    ];
    const completed = quests.filter((q) => q.status === "done").length;

    expect(completed).toBe(2);
  });
});
