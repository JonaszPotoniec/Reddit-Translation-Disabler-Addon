function isRedditDomain(hostname) {
  const redditDomains = [
    "reddit.com",
    "www.reddit.com",
    "old.reddit.com",
    "new.reddit.com",
    "m.reddit.com",
  ];

  return redditDomains.includes(hostname.toLowerCase());
}

function transformUrl(url) {
  try {
    const urlObj = new URL(url);

    if (!isRedditDomain(urlObj.hostname)) {
      return null;
    }

    if (urlObj.searchParams.has("tl")) {
      urlObj.searchParams.delete("tl");

      urlObj.searchParams.set("show", "original");

      return urlObj.toString();
    }

    return null;
  } catch (error) {
    console.error("Reddit Translation Disabler: Error parsing URL:", error);
    return null;
  }
}

function interceptRedditRequests(details) {
  const transformedUrl = transformUrl(details.url);

  if (transformedUrl) {
    return { redirectUrl: transformedUrl };
  }

  return undefined;
}

chrome.webRequest.onBeforeRequest.addListener(
  interceptRedditRequests,
  {
    urls: ["*://*.reddit.com/*"],
  },
  ["blocking"]
);
