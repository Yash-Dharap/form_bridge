# FormBridge Frontend Email Testing - Troubleshooting Guide

## Issue Observed

From your screenshot, the contact form shows:
```
❌ Error: Failed to fetch
```

With CORS errors in the console:
```
Access to fetch at 'https://YOUR_API_ID.execute-api.ap-south-1.amazonaws.com/Prod/submit' 
from origin 'contact.html' has been blocked by CORS policy
```

## Root Causes & Solutions

### Issue 1: CORS Configuration Not Updated

The Lambda function doesn't have the latest CORS headers configured.

**Solution**: The stack needs to be redeployed with the new settings.

**Status**: Your IAM user (OD_User) has restricted permissions. You may need:
- [ ] Admin or IAM user to run `sam deploy`
- [ ] Or ask your AWS account administrator to update the deployment permissions

### Issue 2: Using Direct API Endpoint (Works Around CORS)

If you can't redeploy, use this workaround:

**Use the PowerShell email sender script directly**:

```powershell
.\send_email_via_api.ps1 -Sender "you@example.com" -Recipient "you@example.com"
```

This successfully bypasses the frontend and sends emails directly.

---

## Deployment Instructions for Admin

If you have admin access or can escalate permissions:

### Quick Deploy (1 command)

```bash
cd backend
sam build && sam deploy --stack-name formbridge-stack --capabilities CAPABILITY_IAM --no-confirm-changeset
```

### Using the Batch Script

```cmd
DEPLOY_BACKEND.bat
```

This will:
1. ✅ Build the SAM application
2. ✅ Deploy with correct CORS headers
3. ✅ Configure SES sender/recipients
4. ✅ Enable stage-based naming for DynamoDB

---

## Testing After Deployment

Once redeployed, test from:

### Frontend (Contact Form)
```
https://YOUR_USERNAME.github.io/formbridge/contact.html
```

### PowerShell (Direct API)
```powershell
.\send_email_via_api.ps1
```

### CURL Command
```bash
curl -X POST "https://YOUR_API_ID.execute-api.ap-south-1.amazonaws.com/Prod/submit" \
  -H "Content-Type: application/json" \
  -d '{
    "form_id": "email-test",
    "name": "Om Deshpande",
    "email": "you@example.com",
    "message": "Test message"
  }'
```

---

## Configuration Already Updated

✅ `backend/samconfig.toml` - SES configuration added  
✅ `backend/template.yaml` - CORS headers configured  
✅ `backend/template.yaml` - Stage-based resource naming  
✅ Email scripts created and tested  

**Only pending**: Stack redeployment with new permissions

---

## Current Email Configuration

```yaml
SES Sender: you@example.com (Verified ✅)
Recipients: you@example.com
CORS Origin: https://YOUR_USERNAME.github.io/formbridge/
Region: ap-south-1
```

---

## Workaround for Testing (Until Redeploy)

Use this until deployment:

```powershell
# Send test email
.\send_email_via_api.ps1

# With custom sender (any verified identity)
.\send_email_via_api.ps1 -Sender "you@example.com" -Recipient "you@example.com"
```

✅ **This works immediately** - no frontend CORS issues!

---

## Timeline

1. ✅ Configuration updated (Commits `3f1bf25`, `0f6eb4e`)
2. ⏳ Awaiting stack redeployment (requires IAM permissions)
3. ⏳ Frontend will work after redeployment
4. 📞 Contact AWS account admin to elevate `OD_User` permissions OR
5. 📞 Use an admin account for deployment

---

## Files Ready to Deploy

All files are committed and pushed:

- ✅ `backend/template.yaml` - Updated
- ✅ `backend/samconfig.toml` - Updated  
- ✅ `DEPLOY_BACKEND.bat` - Ready to run
- ✅ `send_email_via_api.ps1` - Fully functional
- ✅ `EMAIL_SETUP_COMPLETE.md` - Documentation

**Commit**: `0f6eb4e` ✅ Pushed to GitHub

---

## Next Steps

**Option A: Redeploy (Best)**
```bash
cd backend && sam build && sam deploy
```

**Option B: Contact Admin**
- Ask AWS account administrator to add CloudFormation permissions to OD_User
- Or use admin account for deployment

**Option C: Use Workaround Now**
```powershell
.\send_email_via_api.ps1
```

---

**Status**: ✅ Configuration complete, ⏳ Awaiting redeployment permissions

