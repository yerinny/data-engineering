# 📝 Git + GitHub Cheat Sheet

This guide helps you connect a local folder to GitHub and manage daily commits for your 100 Days of Data Engineering project.

---

## ✅ One-Time Setup (on your computer)
Run these commands once after installing Git:
```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```
⚠️ Use the same email as your GitHub account.

---

## 🚀 Linking a Local Folder to GitHub (when repo already exists on GitHub)

1. Go to your local project folder:
```bash
cd "path/to/your/folder"
```

2. Initialize Git inside the folder:
```bash
git init
```

3. Connect your GitHub repo (replace URL with yours):
```bash
git remote add origin https://github.com/your-username/repo-name.git
git branch -M main
```

4. Pull existing files from GitHub (e.g., README):
```bash
git pull origin main --allow-unrelated-histories
```

5. Add local files & commit:
```bash
git add .
git commit -m "Initial commit: setup local folder"
```

6. Push everything to GitHub:
```bash
git push origin main
```

---

## 📝 Daily Workflow (repeat every day)
When you add new code, notes, or progress:
```bash
git add .
git commit -m "Day X: description of what you did"
git push
```

---

## ✅ Quick Tips
- Use `git status` anytime to see what changed.
- Use `git log` to see past commits.
- If you forget to pull before pushing and get errors, run:
```bash
git pull origin main --allow-unrelated-histories
```

---

Happy Coding 🚀
