# 🚀 Quick Start - FormBridge Website v2

## 30-Second Setup

### Step 1: Configure Your API
```bash
cp js/config.example.js js/config.js
```

Then edit `js/config.js`:
```javascript
const CONFIG = {
  API_URL: 'https://YOUR_API_ID.execute-api.ap-south-1.amazonaws.com/Prod',
  API_KEY: 'your-demo-key-here',
  FORM_ID: 'contact-us',
};
```

### Step 2: Run Locally
```bash
node server.js
```

### Step 3: Open in Browser
Visit: http://localhost:8080

---

## What's Included

### 📄 Pages (7 total)
- **index.html** - Home page (hero, features, pricing preview)
- **contact.html** - Live contact form
- **pricing.html** - Pricing plans
- **docs.html** - Documentation hub
- **solutions.html** - Use cases
- **blog/index.html** - Blog listing
- **blog/sample-post.html** - Blog template
- **404.html** - Error page

### 🎨 Design
- ✅ Responsive (360px+)
- ✅ Mobile menu
- ✅ Smooth animations
- ✅ Dark footer
- ✅ Accessible (WCAG AA)

### 🔧 Features
- ✅ Live form submission
- ✅ Code tabs with copy-to-clipboard
- ✅ HMAC signature support
- ✅ Toast notifications
- ✅ Analytics integration

### 📦 Stack
- **Styling**: Tailwind CSS (CDN, no build)
- **JavaScript**: Vanilla (4 modular files)
- **Server**: Node.js (simple HTTP server)
- **Deployment**: GitHub Pages ready

---

## Deploy to GitHub Pages

```bash
# 1. Commit all changes
git add .
git commit -m "feat(website-v2): complete SaaS marketing site"

# 2. Push to main
git push origin main

# 3. Verify at:
# https://YOUR_USERNAME.github.io/formbridge/website-v2/
```

---

## File Structure

```
website-v2/
├── 📄 index.html              # Home
├── 📄 contact.html            # Contact form
├── 📄 pricing.html            # Pricing
├── 📄 docs.html               # Docs
├── 📄 solutions.html          # Solutions
├── 📄 404.html                # 404 page
├── 📁 blog/                   # Blog pages
├── 📁 css/
│   └── site.css               # Custom styles
├── 📁 js/
│   ├── config.example.js      # Config template
│   ├── formbridge.js          # API wrapper
│   ├── site.js                # Site utils
│   └── code-tabs.js           # Tab widget
├── 📁 assets/
│   ├── logo.svg               # Logo
│   ├── favicon.ico            # Favicon
│   └── icons/                 # Icons
├── 🔧 server.js               # Dev server
├── 📖 README.md               # Full docs
└── .gitignore
```

---

## Testing Checklist

Before deploying:

- [ ] Run `node server.js` and open http://localhost:8080
- [ ] Test all page links work
- [ ] Submit contact form successfully
- [ ] Test code tabs copy-to-clipboard
- [ ] Check mobile menu on small screens
- [ ] Verify no console errors (F12)
- [ ] Test on mobile device
- [ ] Run Lighthouse audit

---

## Key Files to Know

| File | Purpose |
|------|---------|
| `js/config.js` | Your API credentials (create from example) |
| `js/formbridge.js` | Handles form submission + API calls |
| `js/site.js` | Mobile menu, navigation, smooth scroll |
| `js/code-tabs.js` | Copy-to-clipboard functionality |
| `css/site.css` | Custom animations and components |

---

## Troubleshooting

**Forms not submitting?**
- Check `js/config.js` API_URL and API_KEY
- Open browser console (F12) for errors

**Links broken?**
- Ensure you're accessing from root (`/formbridge/website-v2/`)
- Check that internal links have `data-internal` attribute

**Styling looks wrong?**
- Clear cache (Ctrl+Shift+Delete)
- Check that Tailwind CDN is loading (Network tab in DevTools)

---

## Need Help?

- 📖 Full README: See `README.md`
- 📧 Contact Form: Available on contact.html
- 🎓 Docs: Visit docs.html on the website
- 🐛 Issues: Check browser console (F12)

---

**Ready to launch?** Push to GitHub and your site will be live in 1-2 minutes! 🚀
