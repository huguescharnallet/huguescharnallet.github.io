/* =========================================================
   Association Hugues Charnallet — front-end JS
   - Language toggle (FR / EN)
   - Mobile nav toggle
   - Current-year footer
   ========================================================= */

(function () {
  "use strict";

  const STORAGE_KEY = "ahc-lang";
  const DEFAULT_LANG = "fr";

  /**
   * Returns the active language, reading from localStorage if present,
   * falling back to the <html lang=""> attribute or DEFAULT_LANG.
   */
  function getLang() {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored === "fr" || stored === "en") return stored;
    } catch (_) {}
    const htmlLang = document.documentElement.getAttribute("lang");
    if (htmlLang === "en") return "en";
    return DEFAULT_LANG;
  }

  function setLang(lang) {
    if (lang !== "fr" && lang !== "en") return;
    try { localStorage.setItem(STORAGE_KEY, lang); } catch (_) {}
    document.documentElement.setAttribute("lang", lang);

    // Show/hide <span data-lang="fr"> / <span data-lang="en"> blocks
    document.querySelectorAll("[data-lang]").forEach(function (el) {
      if (el.getAttribute("data-lang") === lang) {
        el.classList.add("visible");
      } else {
        el.classList.remove("visible");
      }
    });

    // Toggle button label
    document.querySelectorAll(".lang-toggle").forEach(function (btn) {
      btn.textContent = lang === "fr" ? "EN" : "FR";
      btn.setAttribute(
        "aria-label",
        lang === "fr" ? "Switch to English" : "Passer en français"
      );
    });

    // Title and meta description (uses data-title-fr/en on <html>)
    const html = document.documentElement;
    const titleFr = html.getAttribute("data-title-fr");
    const titleEn = html.getAttribute("data-title-en");
    if (titleFr || titleEn) {
      document.title = lang === "en" && titleEn ? titleEn : titleFr || document.title;
    }
  }

  function initLangToggle() {
    setLang(getLang());
    document.querySelectorAll(".lang-toggle").forEach(function (btn) {
      btn.addEventListener("click", function () {
        const current = getLang();
        setLang(current === "fr" ? "en" : "fr");
      });
    });
  }

  function initNavToggle() {
    const btn = document.querySelector(".nav-toggle");
    const links = document.querySelector(".nav-links");
    if (!btn || !links) return;
    btn.addEventListener("click", function () {
      links.classList.toggle("open");
      btn.setAttribute(
        "aria-expanded",
        links.classList.contains("open") ? "true" : "false"
      );
    });
  }

  function initFooterYear() {
    const el = document.querySelector("[data-year]");
    if (el) el.textContent = String(new Date().getFullYear());
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", function () {
      initLangToggle();
      initNavToggle();
      initFooterYear();
    });
  } else {
    initLangToggle();
    initNavToggle();
    initFooterYear();
  }
})();
