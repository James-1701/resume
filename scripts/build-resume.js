import { chromium } from "playwright";
import { spawn, execSync } from "child_process";

(async () => {
  const server = spawn("npx", ["serve", ".", "-l", "3000"], {
    stdio: "ignore",
  });

  await new Promise((r) => setTimeout(r, 2000));

  const browser = await chromium.launch({
    ...(process.env.CHROMIUM_PATH
      ? { executablePath: process.env.CHROMIUM_PATH }
      : {}),
  });

  const context = await browser.newContext({
    viewport: { width: 1100, height: 1400 },
    deviceScaleFactor: 3,
  });

  const page = await context.newPage();

  await page.goto("http://localhost:3000/index.html", {
    waitUntil: "networkidle",
  });

  await page.emulateMedia({ media: "print" });

  await page.waitForTimeout(300);

  // const branch = execSync("git rev-parse --abbrev-ref HEAD")
  //   .toString()
  //   .trim()
  //   .replace(/\//g, "-");

  // const filePath = `dist/${branch} resume`;

  const filePath = `dist/resume`;

  await page.pdf({
    path: `${filePath}.pdf`,
    format: "Letter",
    printBackground: true,
    scale: 0.77,
    pageRanges: "1",
  });

  await browser.close();
  server.kill();

  try {
    execSync(
      `pdftoppm -png -singlefile -r 300 "${filePath}.pdf" "${filePath}"`,
    );
  } catch {
    console.warn(`Warning: PNG generation failed. PDF was still created.`);
  }
})();
