# Sri Adhira Engineers website — owner-upload edition

Responsive single-page company website using Tailwind CDN, custom CSS, and vanilla JavaScript. Includes the supplied ADE logo, click-to-call and WhatsApp contact buttons, email enquiry form, SEO foundations, privacy policy starter, a public project gallery, and a private owner upload dashboard.

## Files
- `index.html` — public company website and project gallery
- `admin.html` — private sign-in page to upload, publish/unpublish, and delete project photos/videos
- `assets/ade-logo.png` — logo cropped from the supplied company banner
- `assets/config.js` — Supabase URL and publishable/anon key placeholders
- `supabase-setup.sql` — database and access-control setup
- `privacy.html` — starter privacy policy; review before production

## 1. Publish the website
Netlify is an approachable static host. Sign in at https://app.netlify.com/drop and deploy the extracted `sri_adhira_website` folder. It will get an HTTPS URL. A custom domain is optional. Before the gallery can load real uploads, complete the Supabase steps below. Fonts, Tailwind, Supabase JS, and stock photos load from third-party URLs, so visitors need internet access.

## 2. Configure the owner project-upload dashboard (Supabase)
The gallery upload system requires a small one-time setup; it cannot securely store files by HTML alone.

1. Create a project at https://supabase.com/.
2. In Project Settings → API, copy the Project URL and the publishable key (older projects may call it the `anon` key). Put them into `assets/config.js`:
   - `window.SUPABASE_URL = 'https://YOUR_REAL_PROJECT.supabase.co';`
   - `window.SUPABASE_ANON_KEY = 'YOUR_REAL_PUBLISHABLE_OR_ANON_KEY';`
3. Never put a `service_role` or secret key in `config.js` or any browser file.
4. In Supabase SQL Editor, run all statements from `supabase-setup.sql`.
5. In Storage, create a bucket named exactly `project-media` and mark it **Public** (public means uploaded files are visible to anyone with their media URLs). Configure allowed MIME types: `image/jpeg`, `image/png`, `image/webp`, `image/avif`, `video/mp4`, `video/webm`; set maximum file size to 40 MB (or lower). The SQL script adds read/upload/delete policies for this bucket.
6. In Authentication, create an owner user with email `sriadhiraengineers@gmail.com` and a strong unique password. Disable public sign-ups. Make sure you can sign in with this account. The policies limit dashboard data changes to this email.
7. Save `assets/config.js`, redeploy the whole folder, and open `https://YOUR-SITE-URL/admin.html`. Sign in and upload a test photo marked unpublished first. Check that it does not appear on the public gallery. Then publish it in the admin dashboard. Test a short video as well.
8. Keep the admin URL private. Access control is enforced by Supabase authentication and row/storage policies, not by hiding the URL. Enable MFA for the owner account if available, keep the password private, and never loosen the included SQL policies to anonymous uploads.

The owner dashboard supports one media item per gallery card. To show multiple angles of the same project, upload them as separate entries with a consistent title such as `Anna Nagar Residence — Exterior`, `Anna Nagar Residence — Interior`, etc. Upload clear, compressed images (WebP/JPG preferred) and short MP4/WebM videos. Before publishing, secure client permission to publish their property images and avoid faces, house numbers, security systems, drawings, signatures, or private documents unless authorised.

## 3. Enquiry form email notifications
The form posts to `https://formsubmit.co/sriadhiraengineers@gmail.com`. Deploy first, submit a test enquiry, confirm FormSubmit's activation email, and submit a second test. Check spam. It relies on a third-party processor, so review its current terms and privacy policies. For production, consider a transactional email provider behind a serverless function.

## 4. Add analytics
Create a Google Analytics 4 property at https://analytics.google.com/, create a Web stream, and use its `G-...` Measurement ID. In `index.html`, uncomment the GA block near the top and replace `G-XXXXXXXXXX` in both places. Deploy again, test real-time reports, and later review Users, Views, traffic sources, and geographic dimensions. Add an appropriate consent/privacy approach before enabling analytics. Analytics can take time to appear in standard reports.

## 5. Before launch checklist
- Check that phone `+91 93440 15794`, email, WhatsApp link, address `No. 5, Babuji Nagar, 6th Street, Thiruninravur, Chennai – 602024`, and GSTIN `33GLDPS6447H1ZR` are correct before publishing.
- Replace stock photos in the hero/services/about sections with the company's own work where possible; do not claim stock images are your projects.
- Upload 6–12 strong project photos with useful captions/locations before promoting the site.
- Test on mobile, all links, the enquiry form, owner login, photo upload, video upload, publish/unpublish, and delete.
- Review `privacy.html` and adapt it to actual data handling; this is a starter template, not legal advice.
- Consider compressing/optimizing images, getting a custom domain, and using a company-domain email later.
