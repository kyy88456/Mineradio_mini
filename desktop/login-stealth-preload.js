// desktop/login-stealth-preload.js
// Injected into login BrowserWindows (netease / qq) to mask Electron-specific
// fingerprint signals that 163 / Tencent anti-bot libraries inspect.
// Runs in the same isolated world as the page but BEFORE any page script,
// so the overrides are visible to all subsequent JS on the page.
try {
  Object.defineProperty(navigator, 'webdriver', { get: () => undefined, configurable: true });
} catch (e) {}
try {
  Object.defineProperty(navigator, 'languages', { get: () => ['zh-CN', 'zh', 'en'], configurable: true });
} catch (e) {}
try {
  Object.defineProperty(navigator, 'platform', { get: () => 'Win32', configurable: true });
} catch (e) {}
try {
  Object.defineProperty(navigator, 'plugins', {
    get: () => ({ length: 3, item: (i) => ({ name: ['Chrome PDF Plugin', 'Chrome PDF Viewer', 'Native Client'][i] || '' }) }),
    configurable: true,
  });
} catch (e) {}
try {
  window.chrome = window.chrome || { runtime: {}, app: { isInstalled: false } };
} catch (e) {}
