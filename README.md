# 🚀 OrgAccessApp — Organization-Based Access Control System

A Ruby on Rails application for managing organizations, spaces, posts, and user access using dynamic participation rules. Built with Devise for authentication, Pundit for authorization, and Devise Invitable for invitation workflows.

---

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Participation Rule System](#participation-rule-system)
- [User Roles & Access](#user-roles--access)
- [Contributing](#contributing)

---

## ✅ Features

- 🔐 **Organization-based authentication and access control**
- 👥 **User roles**: Admin, Moderator, Member
- 📩 **User invitations** using Devise Invitable
- 🧩 **Spaces** within organizations
- 📝 **Posts** with RuleSet-based access
- 📊 **RuleSets** and **Rules**: Apply dynamic age-based or custom logic
- ✅ **Participation enforcement**: Only users meeting rules can join a space or view posts
- 📄 **Admin interface**: Manage memberships, spaces, and RuleSets
- 🎨 TailwindCSS-based UI for a clean user experience

---

## 💻 Tech Stack

- **Ruby on Rails** 7.1+
- **PostgreSQL**
- **Pundit** for authorization
- **Devise & Devise Invitable** for user management and invitations
- **Letter Opener** for development mail previews
- **Tailwind CSS** for styling

---

## 🛠 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourname/org_access_app.git
cd org_access_app

bundle install

rails db:create
rails db:setup
rails db:seed

rails server

