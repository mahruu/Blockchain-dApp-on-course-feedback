# Course Feedback Board — Mini dApp (MG3012 Assignment 2)

**Course:** MG3012 – Blockchain Technology for Business (BSFT, Fall 2026) · **Instructor:** Dr. Usama Arshad
**Student:** YOUR NAME · **Roll No:** YOUR ROLL NO

A small decentralized application: a **Solidity smart contract** deployed on the **Sepolia testnet**
plus a **single-page HTML/CSS/JavaScript frontend** that talks to it through **MetaMask** and **ethers.js v6**.
Users can post a short feedback message with a 1–5 star rating, upvote other people's feedback, and see live statistics.

## 🔗 Deployment details

| Item | Value |
|---|---|
| Network | Sepolia testnet (chain ID 11155111) |
| **Contract address** | `0xf072AD0AA7939925E4a2393964382Dc663Ae1a05` |
| Etherscan | https://sepolia.etherscan.io/address/0xf072AD0AA7939925E4a2393964382Dc663Ae1a05 |
| Deployment tx | https://sepolia.etherscan.io/tx/0xPASTE_DEPLOY_TX_HASH |
| GitHub repo | https://github.com/YOUR_USERNAME/YOUR_REPO |

## 📁 Project structure

```
├── SmartContract.sol     Solidity contract (CourseFeedbackBoard)
├── index.html            Frontend: HTML + <script> (ethers.js + MetaMask logic)
├── style.css             Styling
├── README.md             This file
└── screenshots/          Deployment, connection and transaction screenshots
```

## 🧠 Smart contract design (`SmartContract.sol`)

Five functions: two **write**, three **read**.

| # | Function | Type | Purpose |
|---|---|---|---|
| 1 | `postFeedback(string message, uint8 rating)` | write | Stores a new entry. Reverts if the message is empty / over 280 bytes or rating is not 1–5. Emits `FeedbackPosted`. |
| 2 | `upvote(uint256 id)` | write | Adds an upvote. Reverts if the entry doesn't exist, is your own, or you already upvoted it. Emits `Upvoted`. |
| 3 | `getFeedback(uint256 id)` | read | Returns author, message, rating, upvotes, timestamp. |
| 4 | `getFeedbackCount()` | read | Number of entries. |
| 5 | `getAverageRating()` | read | Average rating × 100 (Solidity has no decimals, so `450` = 4.50). |

Design notes: input validation with `require`, events for off-chain tracking, one-upvote-per-address via a nested mapping,
and a running `totalRating` so the average is O(1) instead of looping over all entries.

## 🖥️ Frontend (`index.html`, `style.css`)

* **HTML elements used:** headings (`h1`–`h3`), paragraphs, ordered & unordered lists, links, buttons, an image (`<img>`), form controls, and the `<script>` tag.
* **Styling:** external `style.css` (responsive, works on mobile).
* **JavaScript (inside `<script>`):** connects MetaMask, checks/switches to Sepolia, **reads** count/average/entries, **writes** feedback & upvotes, and shows the transaction hash (linked to Etherscan), block number and gas used.
* **Extra features:** baby-pink kawaii theme with kaomojis, clickable mascot, interactive star-rating picker, character counter, confetti on success, live feedback wall, Etherscan links, loading/error states, XSS-safe rendering (`textContent`), reload on account/network change, reduced-motion support.

## ⚙️ Setup & run

### 1. Prerequisites
* Chrome/Brave/Firefox with the [MetaMask](https://metamask.io/) extension
* Some Sepolia ETH from a faucet (e.g. https://sepolia-faucet.pk910.de/)

### 2. Deploy the contract with Remix
1. Open https://remix.ethereum.org and create `SmartContract.sol`; paste the code.
2. **Solidity Compiler** tab → version **0.8.20 or newer** → *Compile*.
3. **Deploy & Run** tab → Environment: **Injected Provider – MetaMask** → make sure MetaMask is on **Sepolia**.
4. Select `CourseFeedbackBoard` → *Deploy* → confirm in MetaMask.
5. Copy the deployed address from "Deployed Contracts".

### 3. Connect the frontend
1. Open `index.html` and replace the placeholder near the top of the `<script>`:
   ```js
   const CONTRACT_ADDRESS = "0xYourContractAddressHere";
   ```
2. Open `index.html` in your browser (double-click, or run `python -m http.server` and visit `http://localhost:8000`).
3. Click **Connect MetaMask** → post feedback → confirm in MetaMask → watch the result box.

### 4. (Bonus) Verify on Etherscan
Etherscan Sepolia → your contract → *Contract* → *Verify & Publish* → Compiler type *Solidity (Single file)*,
same compiler version as Remix, optimization setting as in Remix, license MIT → paste `SmartContract.sol`.
(Or use Remix's *Contract Verification* plugin.)

## 📸 Screenshots
See the `screenshots/` folder: (1) contract deployment in Remix, (2) wallet connected in the UI, (3) a confirmed transaction.

## ✅ Testing
The contract was compiled with solc 0.8.24 and tested for: empty/over-length messages, invalid ratings, average calculation,
duplicate & self upvotes, and non-existent IDs. The frontend flow (connect → read → post → upvote) was exercised end-to-end in Chromium.

## 📝 License
MIT
