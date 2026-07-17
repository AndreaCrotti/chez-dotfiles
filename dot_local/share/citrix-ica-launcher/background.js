const NATIVE_HOST = "com.andreacrotti.ica_launcher";

function isIcaResponse(headers) {
  const ct = (headers || []).find(
    (h) => h.name.toLowerCase() === "content-type"
  );
  return !!ct && ct.value.toLowerCase().startsWith("application/x-ica");
}

// onHeadersReceived can fire twice in quick succession for the same URL
// (e.g. a duplicate/prefetch request); re-downloading immediately triggers
// a 429 from Citrix. Debounce per-URL for 5s.
// ponytail: in-memory Set resets if the MV3 service worker gets suspended
// between the two requests; move to chrome.storage.session if 5s isn't enough.
const recentDownloads = new Set();
const DEDUPE_WINDOW_MS = 5000;

// Observational only (no "webRequestBlocking") — we never modify the request.
chrome.webRequest.onHeadersReceived.addListener(
  (details) => {
    if (!isIcaResponse(details.responseHeaders)) return;
    if (recentDownloads.has(details.url)) return;
    recentDownloads.add(details.url);
    setTimeout(() => recentDownloads.delete(details.url), DEDUPE_WINDOW_MS);
    chrome.downloads.download({ url: details.url });
  },
  { urls: ["<all_urls>"] },
  ["responseHeaders"]
);

// chrome.downloads already remembers each item's mime/filename, which
// survives MV3 service-worker suspension (an in-memory pending-ids set
// here would not), so there's no need for separate bookkeeping.
chrome.downloads.onChanged.addListener((delta) => {
  if (!delta.state || delta.state.current !== "complete") return;
  chrome.downloads.search({ id: delta.id }, ([item]) => {
    if (!item) return;
    const looksLikeIca =
      (item.mime && item.mime.toLowerCase().startsWith("application/x-ica")) ||
      item.filename.toLowerCase().endsWith(".ica");
    if (!looksLikeIca) return;
    chrome.runtime.sendNativeMessage(
      NATIVE_HOST,
      { path: item.filename },
      () => {
        if (chrome.runtime.lastError) {
          console.error(chrome.runtime.lastError.message);
        }
      }
    );
  });
});
