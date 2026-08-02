// FormBridge Site Configuration
// Copy this file to config.js and update with your settings

window.CONFIG = {
  // GitHub Pages base path (use /formbridge for root/docs folder deployment)
  PAGES_BASE: "/formbridge",
  
  // API Configuration
  API_URL: "https://YOUR_API_ID.execute-api.ap-south-1.amazonaws.com/Prod",
  API_KEY: "your-api-key-here", // Demo key (rotate in production)
  FORM_ID: "contact-us",
  
  // HMAC Signature (optional, only if API requires it)
  HMAC_ENABLED: false,
  HMAC_SECRET: "",
  
  // Dashboard link
  DASHBOARD_URL: "https://YOUR_USERNAME.github.io/formbridge/dashboard",
  
  // Feature flags
  ENABLE_ANALYTICS: true
};

// For local development (http://localhost:8080):
// window.CONFIG.PAGES_BASE = "";
// window.CONFIG.API_URL = "http://127.0.0.1:3000";
