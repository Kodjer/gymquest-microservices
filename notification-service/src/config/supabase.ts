// src/config/supabase.ts
import dotenv from "dotenv";

dotenv.config();

export const SUPABASE_URL = process.env.SUPABASE_URL || "";
export const SUPABASE_KEY = process.env.SUPABASE_ANON_KEY || "";

if (!SUPABASE_URL || !SUPABASE_KEY) {
  throw new Error("Supabase URL и ключ обязательны для работы!");
}

export async function supabaseRequest(
  method: string,
  table: string,
  body?: any,
  query?: string
) {
  const url = `${SUPABASE_URL}/rest/v1/${table}${query || ""}`;

  const options: any = {
    method,
    headers: {
      apikey: SUPABASE_KEY,
      Authorization: `Bearer ${SUPABASE_KEY}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
    },
  };

  if (body) {
    options.body = JSON.stringify(body);
  }

  const response = await fetch(url, options);

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Supabase error:  - {"error":"TypeError: fetch failed"} {"error":"TypeError: fetch failed"} {"error":"TypeError: fetch failed"} {"error":"requested path is invalid"} 



Error


Cannot GET /test-db


 



Error


Cannot GET /test-db


 {"error":"TypeError: fetch failed"} Имя "сInvoke-RestMethod" не распознано как имя командлета, функции, файла сценария или выполняемой программы. Проверьте правильность написания имени, а также наличие и правильность пути, после чего повторите попытку. {"error":"TypeError: fetch failed"} {"error":"TypeError: fetch failed"} Не удается найти путь "C:\Users\Кишкодер17\gymquest-microservices\.env", так как он не существует. Имя "сcd" не распознано как имя командлета, функции, файла сценария или выполняемой программы. Проверьте правильность написания имени, а также наличие и правильность пути, после чего повторите попытку. {"error":"TypeError: fetch failed"} 



Error


Cannot GET /api/quests


 Не удается найти параметр, соответствующий имени параметра "Chord". Не удается найти параметр, соответствующий имени параметра "Chord". Не удается найти параметр, соответствующий имени параметра "Chord". Не удается найти параметр, соответствующий имени параметра "Chord".`);
  }

  const text = await response.text();
  return text ? JSON.parse(text) : null;
}
