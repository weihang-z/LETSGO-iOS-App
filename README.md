# Travel App – Tab3-4Feature Overview

This branch using local mock data to simulate group travel, journals, and personal profile features. Below is the current feature explanation and the roadmap for upcoming improvements.

---

## Tab 3: Travel Groups

### **Current Features**
- Displays travel groups using local mock data.
- The `GroupList` page presents groups with a custom `GroupCardCell` UI.
- Tapping a card navigates to a detailed group view (destination, budget, member count, date, etc.).
- A **“+ Create”** button allows users to create new group entries; saved data immediately refreshes the list (in-memory storage).
- All data is currently stored locally in memory with no Firebase or external database integration yet.

### **Planned Improvements**
- **Firebase Integration**: View the newest travel groups instantly using real-time updates when opening Tab 3.
- **Filter System**: Filter groups by budget, date, city, or theme.
- **Enhanced Group Detail Page**: Show organizer profile, member list, and join/leave functionality.
---

## Tab 4: My Profile

### **Current Features**
- Profile Overview page presents:
  - User avatar  
  - Username  
  - Bio  
  - Three statistic cards:
    - **Cities Visited**
    - **Travel Days**
    - **Journal Count**
- Two main navigation entries:
  - **Edit Profile**: Allows editing username and bio; updates UI through callback closure (data stored locally).
  - **My Posts**: Switches between “Groups / Journals” to display the user’s sample travel groups and journals.

### **Planned Improvements**
- **Firebase Sync for Profile**: Avatar, username, bio, and travel statistics will be uploaded and synced via Firebase.
- **Avatar Editing & Upload** (Firebase Storage).
- **Post History Detail Pages**: Open individual journal or group posts for a full detailed view.
- **Followers / Following System**: View follower list, following list, and other users’ profiles.
- **Travel Footprint Map**: Visual map showing all cities the user has visited.

---
# LETSGO – App Overview

## Core Concept
Our app helps travelers **capture, organize, and relive their journey memories** through a clean timeline-based interface, while also enabling them to **find compatible travel companions** through thoughtful social features.

Users can document their trips, organize travel journals chronologically, and connect with others who share similar destinations and interests.

---

## Target Audience

### • College Students & Young Adults (18–35)
People who love traveling but prefer **not to travel alone**, and want a simple way to connect with like-minded companions.

### • Memory Keepers  
Travelers who want to keep a **personal archive** of their journeys and prefer meaningful journaling over quick, disposable social media posts.

---

##  Significance: Connecting Travelers, Collecting Memories

### **Social Context**
- Gen Z and Millennials experience increasing **“social media fatigue.”** They travel more but want to preserve their experiences more meaningfully.
- Many travelers feel lonely or unsafe traveling solo.
- Existing apps (e.g., TripAdvisor) focus on destinations rather than companionship.
- Travelers want a safe, focused environment for sharing meaningful moments.

### **Our App’s Unique Value**
- We provide the perfect balance between:
  - **Private Journal** (too isolated)  
  - **Social Media** (too exposed)  
  → **Our App: Just Right.**
- Your travel stories are organized **by time, not algorithm**. Memories are preserved instead of buried in feeds.
- The app fosters **real connections**, helping users team up and plan trips more easily.

---

## 🌟 Key Features

### **1. Chronological Travel Journals**
- Users can create journal entries with photos, stories, and dates.  
- Entries are displayed in a **clean timeline layout** for easy browsing.  
- Helps users maintain a personal archive of their journeys.

### **2. Selective Sharing & Privacy Controls**
- Journals and posts can be shared only with **close friends or selected groups**.  
- Users control the level of visibility (private, friends-only, public).

### **3. Find Travel Companions**
- Many people want to travel but struggle to find partners.  
- The app suggests compatible travel buddies based on:
  - **Location**
  - **Interests**
  - **Schedule / travel dates**
- Helps reduce travel anxiety and makes trip planning easier.

---

## 📌 Summary
This app is designed for travelers who want to **preserve their memories**, share meaningful stories, and **find companionship** on future trips.  
It is a bridge between personal journaling and social connection, built for modern travelers who seek authenticity, organization, and community.

