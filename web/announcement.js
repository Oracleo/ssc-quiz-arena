// ============================================================
// SSC QUIZ ARENA — ANNOUNCEMENT CONFIG
// Edit this file to change the notice shown on the homepage.
// No coding needed — just edit the text below and push to GitHub.
// ============================================================

const ANNOUNCEMENT = {

  // Set to false to hide the banner completely
  enabled: true,

  // "info" = blue, "success" = green, "warning" = gold, "promo" = purple
  type: "promo",

  // The icon shown on the left (use any single character or symbol)
  icon: "📚",

  // Main bold heading
  title: "India's Most Complete SSC Question Bank",

  // Subtitle text below the heading
  subtitle: "All premium GK books — Lucent, Arihant, Vision IAS — combined into one free platform. 10 subjects · 500+ questions · Updated regularly.",

  // Optional badge text shown top-right of the banner (leave empty "" to hide)
  badge: "FREE ACCESS",

};

// ── DO NOT EDIT BELOW THIS LINE ─────────────────────────────
// Makes the config available to Flutter via a global variable.
if (typeof window !== "undefined") {
  window.SSC_ANNOUNCEMENT = ANNOUNCEMENT;
}
