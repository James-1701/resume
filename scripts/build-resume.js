const { chromium } = require("playwright");
const { spawn, execSync } = require("child_process");

(async () => {
  const server = spawn("npx", ["serve", ".", "-l", "3000"], {
    stdio: "ignore",
  });

  await new Promise((r) => setTimeout(r, 2000));

  const browser = await chromium.launch();

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

  await page.pdf({
    path: "resume.pdf",
    format: "Letter",
    printBackground: true,
    scale: 0.78,
    pageRanges: "1",
  });

  await browser.close();
  server.kill();

  execSync("pdftoppm -png -singlefile -r 300 resume.pdf resume");
})();
