   const slotMeta = {
      weapon: { label: "Weapon", icon: "🪄" },
      offhand: { label: "Offhand", icon: "🛡️" },
      ring: { label: "Ring", icon: "💍" },
      boots: { label: "Boots", icon: "🥾" },
      charm: { label: "Charm", icon: "✨" }
    };

    const itemDefs = {
      starterWand: {
        type: "equip",
        slot: "weapon",
        name: "Starter Wand",
        icon: "🪄",
        desc: "+2 Atk",
        mods: { attack: 2 }
      },
      twigWand: {
        type: "equip",
        slot: "weapon",
        name: "Twig Wand",
        icon: "🪄",
        desc: "+3 Atk",
        mods: { attack: 3 }
      },
      barkBuckler: {
        type: "equip",
        slot: "offhand",
        name: "Bark Buckler",
        icon: "🛡️",
        desc: "+1 Armor",
        mods: { armor: 1 }
      },
      moonBoots: {
        type: "equip",
        slot: "boots",
        name: "Moon Boots",
        icon: "🥾",
        desc: "+6% Dodge",
        mods: { dodge: 0.06 }
      },
      rubyRing: {
        type: "equip",
        slot: "ring",
        name: "Ruby Ring",
        icon: "💍",
        desc: "+7% Crit",
        mods: { crit: 0.07 }
      },
      heartCharm: {
        type: "equip",
        slot: "charm",
        name: "Heart Charm",
        icon: "❤️",
        desc: "+16 HP",
        mods: { maxHp: 16 }
      },
      luckyLeaf: {
        type: "equip",
        slot: "charm",
        name: "Lucky Leaf",
        icon: "🍀",
        desc: "+1 Atk • +3% Crit",
        mods: { attack: 1, crit: 0.03 }
      },
      lidShield: {
        type: "equip",
        slot: "offhand",
        name: "Lid Shield",
        icon: "🪵",
        desc: "+1 Armor",
        mods: { armor: 1 }
      },
      trollPebble: {
        type: "equip",
        slot: "charm",
        name: "Troll Pebble",
        icon: "🪨",
        desc: "+2 Atk",
        mods: { attack: 2 }
      },
      shrineBlessing: {
        type: "passive",
        name: "Shrine Blessing",
        icon: "🌙",
        desc: "+6% Crit",
        mods: { crit: 0.06 }
      },
      wolfPupFavor: {
        type: "passive",
        name: "Wolf Pup Favor",
        icon: "🐾",
        desc: "+5% Dodge",
        mods: { dodge: 0.05 }
      },
      frogTonic: {
        type: "passive",
        name: "Frog Tonic",
        icon: "🧪",
        desc: "+12 HP",
        mods: { maxHp: 12 }
      }
    };

    const enemies = [
      { name: "Moss Slime", emoji: "🟢", hp: 36, attack: 8, gold: 10, intro: "A slime jiggles onto the trail." },
      { name: "Sneaky Goblin", emoji: "👺", hp: 48, attack: 10, gold: 15, intro: "A goblin skids in with a rusty grin." },
      { name: "Bat Swarm", emoji: "🦇", hp: 54, attack: 11, gold: 18, intro: "A cloud of bats erupts from the trees." },
      { name: "Bone Knight", emoji: "💀", hp: 68, attack: 13, gold: 24, intro: "A rattling knight steps from the dark." },
      { name: "Forest Wyrm", emoji: "🐉", hp: 86, attack: 15, gold: 36, intro: "A wyrm descends from the moonlit sky." }
    ];

    const questions = [
      { text: "Bats are the only mammals capable of true flight.", answer: true },
      { text: "Goldfish only remember things for three seconds.", answer: false },
      { text: "Honey can stay edible for thousands of years.", answer: true },
      { text: "Bananas grow on trees.", answer: false },
      { text: "Lightning never strikes the same place twice.", answer: false },
      { text: "Octopuses have three hearts.", answer: true },
      { text: "The Great Wall is clearly visible from space with the naked eye.", answer: false },
      { text: "Tomatoes are botanically fruits.", answer: true },
      { text: "Sharks are mammals.", answer: false },
      { text: "A group of crows can be called a murder.", answer: true },
      { text: "Koalas have fingerprints very similar to humans.", answer: true },
      { text: "Sound travels faster than light.", answer: false },
      { text: "Venus is the hottest planet in our solar system.", answer: true },
      { text: "Humans have only five senses.", answer: false },
      { text: "The human body has four lungs.", answer: false },
      { text: "A day on Mercury is longer than a year on Mercury.", answer: true },
      { text: "Owls can rotate their heads a full 360 degrees.", answer: false },
      { text: "An avocado is a berry.", answer: true },
      { text: "There are more stars than grains of sand on Earth.", answer: true },
      { text: "Glass is a very slow-moving liquid.", answer: false },
      { text: "The Eiffel Tower gets slightly taller in hot weather.", answer: true },
      { text: "Penguins can fly short distances.", answer: false },
      { text: "The shortest recorded war lasted less than an hour.", answer: true },
      { text: "Your tongue has separate taste zones.", answer: false },
      { text: "Wombat poop is cube-shaped.", answer: true }
    ];

    const eventDeck = [
      {
        prompt: "A lost lady asks for help.",
        promptCopy: "Choose what to do.",
        choices: {
          true: {
            title: "Help the lady.",
            copy: "Offer your help.",
            glyph: "🤝",
            badge: "Help"
          },
          false: {
            title: "Walk away.",
            copy: "Keep moving.",
            glyph: "🍂",
            badge: "Pass"
          }
        },
        onChoose(choice, state) {
          if (choice) {
            if (Math.random() < 0.72) {
              healPlayer(12);
              state.player.gold += 8;
              state.player.apples += 1;
              return "You help her. +12 HP, +8 gold, +1 apple.";
            }
            const lostGold = Math.min(state.player.gold, 12);
            state.player.gold -= lostGold;
            return `She steals ${lostGold} gold and vanishes.`;
          }
          return "You keep moving.";
        }
      },
      {
        prompt: "A chest glows in the dark.",
        promptCopy: "Choose what to do.",
        choices: {
          true: {
            title: "Open the chest.",
            copy: "Take the risk.",
            glyph: "🧰",
            badge: "Open"
          },
          false: {
            title: "Leave the chest.",
            copy: "Walk past it.",
            glyph: "🍂",
            badge: "Leave"
          }
        },
        onChoose(choice, state) {
          if (choice) {
            if (Math.random() < 0.55) {
              state.player.gold += 18;
              return "It was treasure. +18 gold.";
            }
            takePlayerDamage(10);
            return "It bites. -10 HP.";
          }
          addBackpackItem(itemDefs.lidShield);
          return "You take the lid. Lid Shield added.";
        }
      },
      {
        prompt: "A shrine hums softly.",
        promptCopy: "Choose what to do.",
        choices: {
          true: {
            title: "Bow to the shrine.",
            copy: "Show respect.",
            glyph: "🌙",
            badge: "Bow"
          },
          false: {
            title: "Ignore the shrine.",
            copy: "Keep your distance.",
            glyph: "🚶",
            badge: "Ignore"
          }
        },
        onChoose(choice, state) {
          if (choice) {
            const tithe = Math.min(state.player.gold, 6);
            state.player.gold -= tithe;
            addPassive(itemDefs.shrineBlessing);
            return `You pay ${tithe} gold. Shrine Blessing gained.`;
          }
          takePlayerDamage(7);
          return "The shrine zaps you. -7 HP.";
        }
      },
      {
        prompt: "A wolf pup wants food.",
        promptCopy: "Choose what to do.",
        choices: {
          true: {
            title: "Feed the wolf pup.",
            copy: "Make a small offering.",
            glyph: "🐾",
            badge: "Feed"
          },
          false: {
            title: "Shoo the wolf pup.",
            copy: "Send it away.",
            glyph: "🍃",
            badge: "Shoo"
          }
        },
        onChoose(choice, state) {
          if (choice) {
            const cost = Math.min(state.player.gold, 5);
            state.player.gold -= cost;
            addPassive(itemDefs.wolfPupFavor);
            return `You feed it for ${cost} gold. Pup Favor gained.`;
          }
          takePlayerDamage(6);
          return "It bites your ankle. -6 HP.";
        }
      },
      {
        prompt: "A troll demands bridge tax.",
        promptCopy: "Choose what to do.",
        choices: {
          true: {
            title: "Pay the troll tax.",
            copy: "Cross safely.",
            glyph: "🪙",
            badge: "Pay"
          },
          false: {
            title: "Bluff the troll.",
            copy: "Try your luck.",
            glyph: "🎭",
            badge: "Bluff"
          }
        },
        onChoose(choice, state) {
          if (choice) {
            const tax = Math.min(state.player.gold, 7);
            state.player.gold -= tax;
            addBackpackItem(itemDefs.trollPebble);
            return `You pay ${tax} gold. Troll Pebble added.`;
          }
          if (Math.random() < 0.5) {
            state.player.gold += 10;
            return "Your bluff works. +10 gold.";
          }
          takePlayerDamage(9);
          return "The troll slams you. -9 HP.";
        }
      },
      {
        prompt: "A frog merchant offers a potion.",
        promptCopy: "Choose what to do.",
        choices: {
          true: {
            title: "Drink the potion.",
            copy: "Trust the frog merchant.",
            glyph: "🧪",
            badge: "Drink"
          },
          false: {
            title: "Refuse the potion.",
            copy: "Play it safe.",
            glyph: "🐸",
            badge: "Refuse"
          }
        },
        onChoose(choice, state) {
          if (choice) {
            if (Math.random() < 0.6) {
              addPassive(itemDefs.frogTonic);
              healPlayer(12);
              return "It works. Frog Tonic gained. +12 HP.";
            }
            const loss = Math.min(state.player.gold, 9);
            state.player.gold -= loss;
            return `Bad side effects. Lose ${loss} gold.`;
          }
          state.player.gold += 5;
          return "He pays you for being careful. +5 gold.";
        }
      }
    ];

    const shopPool = [
      {
        name: "Twig Wand",
        icon: "🪄",
        cost: 12,
        desc: "+3 Atk",
        onBuy() {
          addBackpackItem(itemDefs.twigWand);
        }
      },
      {
        name: "Bark Buckler",
        icon: "🛡️",
        cost: 11,
        desc: "+1 Armor",
        onBuy() {
          addBackpackItem(itemDefs.barkBuckler);
        }
      },
      {
        name: "Moon Boots",
        icon: "🥾",
        cost: 13,
        desc: "+6% Dodge",
        onBuy() {
          addBackpackItem(itemDefs.moonBoots);
        }
      },
      {
        name: "Ruby Ring",
        icon: "💍",
        cost: 14,
        desc: "+7% Crit",
        onBuy() {
          addBackpackItem(itemDefs.rubyRing);
        }
      },
      {
        name: "Apple Bundle",
        icon: "🍎",
        cost: 8,
        desc: "+2 Apples",
        onBuy() {
          state.player.apples += 2;
        }
      },
      {
        name: "Heart Charm",
        icon: "❤️",
        cost: 15,
        desc: "+16 HP",
        onBuy() {
          addBackpackItem(itemDefs.heartCharm);
        }
      },
      {
        name: "Lucky Leaf",
        icon: "🍀",
        cost: 10,
        desc: "+1 Atk • +3% Crit",
        onBuy() {
          addBackpackItem(itemDefs.luckyLeaf);
        }
      }
    ];

    const els = {
      avatarBtn: document.getElementById("avatarBtn"),
      hudAvatar: document.getElementById("hudAvatar"),
      hudName: document.getElementById("hudName"),
      hudHp: document.getElementById("hudHp"),
      hudGold: document.getElementById("hudGold"),
      hudApples: document.getElementById("hudApples"),
      enemyMiniFill: document.getElementById("enemyMiniFill"),
      playerFighter: document.getElementById("playerFighter"),
      enemyFighter: document.getElementById("enemyFighter"),
      playerSprite: document.getElementById("playerSprite"),
      enemySprite: document.getElementById("enemySprite"),
      playerName: document.getElementById("playerName"),
      enemyName: document.getElementById("enemyName"),
      playerSlash: document.getElementById("playerSlash"),
      enemySlash: document.getElementById("enemySlash"),
      damageLayer: document.getElementById("damageLayer"),
      promptTitle: document.getElementById("promptTitle"),
      promptCopy: document.getElementById("promptCopy"),
      cardGrid: document.getElementById("cardGrid"),
      modalBackdrop: document.getElementById("modalBackdrop"),
      modalAvatar: document.getElementById("modalAvatar"),
      modalTitle: document.getElementById("modalTitle"),
      modalStats: document.getElementById("modalStats"),
      equipmentGrid: document.getElementById("equipmentGrid"),
      backpackGrid: document.getElementById("backpackGrid"),
      passiveGrid: document.getElementById("passiveGrid"),
      modalAppleBtn: document.getElementById("modalAppleBtn"),
      closeModalBtn: document.getElementById("closeModalBtn")
    };

    const state = {
      mode: "quiz",
      lock: false,
      modalOpen: false,
      revealRunning: false,
      hidePrompt: false,
      player: null,
      passives: [],
      enemyIndex: 0,
      enemyHp: 0,
      currentQuestion: null,
      currentEvent: null,
      currentShop: [],
      questionDeck: [],
      combo: 0,
      itemId: 0,
      pendingEnemyAdvance: false,
      lastMessage: ""
    };

    function shuffle(arr) {
      const clone = [...arr];
      for (let i = clone.length - 1; i > 0; i -= 1) {
        const j = Math.floor(Math.random() * (i + 1));
        [clone[i], clone[j]] = [clone[j], clone[i]];
      }
      return clone;
    }

    function pick(arr) {
      return arr[Math.floor(Math.random() * arr.length)];
    }

    function clamp(value, min, max) {
      return Math.max(min, Math.min(max, value));
    }

    function wait(ms) {
      return new Promise((resolve) => setTimeout(resolve, ms));
    }

    function makeItem(def) {
      return {
        id: ++state.itemId,
        type: def.type,
        slot: def.slot || null,
        name: def.name,
        icon: def.icon,
        desc: def.desc,
        mods: { ...(def.mods || {}) }
      };
    }

    function addBackpackItem(def) {
      state.player.backpack.unshift(makeItem(def));
      renderAll();
    }

    function addPassive(def) {
      const exists = state.passives.some((passive) => passive.name === def.name);
      if (!exists) {
        state.passives.unshift(makeItem(def));
        clampPlayerHp();
        renderAll();
      }
    }

    function getPlayerBuild() {
      const player = state.player;
      const equipment = Object.values(player.equipment).filter(Boolean);
      const all = equipment.concat(state.passives);

      let attack = player.baseAttack;
      let armor = player.baseArmor;
      let crit = player.baseCrit;
      let dodge = player.baseDodge;
      let maxHp = player.baseMaxHp;

      all.forEach((item) => {
        attack += item.mods.attack || 0;
        armor += item.mods.armor || 0;
        crit += item.mods.crit || 0;
        dodge += item.mods.dodge || 0;
        maxHp += item.mods.maxHp || 0;
      });

      return {
        attack,
        armor,
        crit,
        dodge,
        maxHp
      };
    }

    function clampPlayerHp() {
      const build = getPlayerBuild();
      state.player.hp = Math.min(state.player.hp, build.maxHp);
    }

    function healPlayer(amount) {
      const build = getPlayerBuild();
      state.player.hp = Math.min(build.maxHp, state.player.hp + amount);
    }

    function takePlayerDamage(amount) {
      state.player.hp = Math.max(0, state.player.hp - amount);
    }

    function formatMods(mods) {
      const parts = [];
      if (mods.attack) parts.push(`+${mods.attack} Atk`);
      if (mods.armor) parts.push(`+${mods.armor} Armor`);
      if (mods.crit) parts.push(`+${Math.round(mods.crit * 100)}% Crit`);
      if (mods.dodge) parts.push(`+${Math.round(mods.dodge * 100)}% Dodge`);
      if (mods.maxHp) parts.push(`+${mods.maxHp} HP`);
      return parts.join(" • ") || "No bonus";
    }

    function openModal() {
      state.modalOpen = true;
      els.modalBackdrop.hidden = false;
      renderModal();
    }

    function closeModal() {
      state.modalOpen = false;
      els.modalBackdrop.hidden = true;
    }

    function equipBackpackItem(itemId) {
      const index = state.player.backpack.findIndex((item) => item.id === itemId);
      if (index === -1) return;

      const item = state.player.backpack[index];
      if (item.type !== "equip") return;

      const slot = item.slot;
      const current = state.player.equipment[slot];

      state.player.backpack.splice(index, 1);

      if (current) {
        state.player.backpack.unshift(current);
      }

      state.player.equipment[slot] = item;
      clampPlayerHp();
      renderAll();
    }

    function unequipSlot(slot) {
      const current = state.player.equipment[slot];
      if (!current) return;
      state.player.backpack.unshift(current);
      state.player.equipment[slot] = null;
      clampPlayerHp();
      renderAll();
    }

    function eatApple() {
      if (state.player.apples <= 0 || state.mode === "gameover" || state.mode === "victory") return;
      state.player.apples -= 1;
      healPlayer(18);
      updateBanner("Apple eaten. +18 HP.");
      renderAll();
    }

    function setEnemy(enemy, immediate = false) {
      els.enemyName.textContent = enemy.name;
      els.enemySprite.textContent = enemy.emoji;
      els.enemyFighter.classList.remove("defeated", "entering", "show", "hit", "attacking");

      if (!immediate) {
        els.enemyFighter.classList.add("entering");
        requestAnimationFrame(() => {
          requestAnimationFrame(() => {
            els.enemyFighter.classList.add("show");
          });
        });
      }
    }

    function updateBanner(text) {
      state.lastMessage = text;
      if (!state.hidePrompt && !state.revealRunning) {
        els.promptCopy.textContent = text;
      }
    }

    function setCardGridMode(mode = "default") {
      els.cardGrid.className = mode === "two" ? "card-grid two-card" : "card-grid";
    }

    function renderHud() {
      const build = getPlayerBuild();
      els.hudAvatar.textContent = state.player.emoji;
      els.hudName.textContent = state.player.name;
      els.playerSprite.textContent = state.player.emoji;
      els.playerName.textContent = state.player.name;
      els.hudHp.textContent = `${state.player.hp} / ${build.maxHp}`;
      els.hudGold.textContent = state.player.gold;
      els.hudApples.textContent = state.player.apples;
    }

    function renderScene() {
      const enemy = enemies[state.enemyIndex];
      const enemyPct = (state.enemyHp / enemy.hp) * 100;
      els.enemyMiniFill.style.width = `${clamp(enemyPct, 0, 100)}%`;
      els.enemySprite.textContent = enemy.emoji;
      els.enemyName.textContent = enemy.name;
    }

    function renderPrompt() {
      if (state.revealRunning || state.hidePrompt) return;

      const mode = state.mode;

      if (mode === "quiz") {
        if (!state.currentQuestion) {
          els.cardGrid.innerHTML = "";
          return;
        }

        const q = state.currentQuestion;
        els.promptTitle.textContent = q.text;
        els.promptCopy.textContent = "Pick true or false.";

        setCardGridMode("two");
        const cards = [
          createAnswerCard({
            value: true,
            tag: "",
            title: "TRUE",
            copy: "Trust it",
            glyph: "✔",
            layout: "default",
            hideTag: true
          }),
          createAnswerCard({
            value: false,
            tag: "",
            title: "FALSE",
            copy: "Call bluff",
            glyph: "✖",
            layout: "default",
            hideTag: true
          })
        ];

        els.cardGrid.innerHTML = cards.join("");
paintAnswerCardCanvases();
attachAnswerHandlers();
animateFreshCards();
return;
      }

      if (mode === "event") {
        const e = state.currentEvent;
        els.promptTitle.textContent = e.prompt;
        els.promptCopy.textContent = e.promptCopy || "Choose what to do.";

        const yesChoice = e.choices.true;
        const noChoice = e.choices.false;

        setCardGridMode("two");
        const cards = [
          createAnswerCard({
            value: true,
            tag: "",
            title: yesChoice.title,
            copy: yesChoice.copy,
            glyph: yesChoice.glyph,
            layout: "event",
            hideTag: true
          }),
          createAnswerCard({
            value: false,
            tag: "",
            title: noChoice.title,
            copy: noChoice.copy,
            glyph: noChoice.glyph,
            layout: "event",
            hideTag: true
          })
        ];

        els.cardGrid.innerHTML = cards.join("");
paintAnswerCardCanvases();
attachEventHandlers();
animateFreshCards();
return;
      }

      if (mode === "shop") {
        els.promptTitle.textContent = "A wandering merchant appears.";
        els.promptCopy.textContent = state.lastMessage || "Buy gear, apples, or leave.";

        setCardGridMode();
        const cards = state.currentShop.map((item, index) => createShopCard(item, index)).concat(createLeaveCard());
        els.cardGrid.innerHTML = cards.join("");
attachShopHandlers();
animateFreshCards();
return;
      }

      if (mode === "gameover") {
        els.promptTitle.textContent = "The forest wins this round.";
        els.promptCopy.textContent = `You reached enemy ${state.enemyIndex + 1} of ${enemies.length}.`;

        setCardGridMode("two");
        els.cardGrid.innerHTML = `
          <button class="play-card true-card card-pre-enter" type="button" id="restartCard" style="--tilt:0deg;">
            <span class="card-corner">RE</span>
            <span class="card-corner bottom">RE</span>
            <span class="card-glyph">🔁</span>
            <div class="card-body">
              <span class="card-tag">New Run</span>
              <h4 class="card-title">Restart</h4>
              <p class="card-copy">Jump back in.</p>
            </div>
          </button>
        `;
        document.getElementById("restartCard").addEventListener("click", resetGame);
animateFreshCards();
return;
      }

      if (mode === "victory") {
        els.promptTitle.textContent = "You cleared the Forest of Fate.";
        els.promptCopy.textContent = `You survived with ${state.player.hp} HP and ${state.player.gold} gold.`;

        setCardGridMode("two");
        els.cardGrid.innerHTML = `
          <button class="play-card true-card card-pre-enter" type="button" id="victoryRestart" style="--tilt:0deg;">
            <span class="card-corner">GG</span>
            <span class="card-corner bottom">GG</span>
            <span class="card-glyph">🌅</span>
            <div class="card-body">
              <span class="card-tag">Again</span>
              <h4 class="card-title">New Adventure</h4>
              <p class="card-copy">Start over.</p>
            </div>
          </button>
        `;
        document.getElementById("victoryRestart").addEventListener("click", resetGame);
animateFreshCards();
      }
    }

    function renderModal() {
      if (!state.modalOpen) return;

      const build = getPlayerBuild();

      els.modalAvatar.textContent = state.player.emoji;
      els.modalTitle.textContent = state.player.name;
      els.modalAppleBtn.textContent = state.player.apples > 0 ? `Eat Apple (+18 HP) • ${state.player.apples}` : "No Apples";
      els.modalAppleBtn.disabled = state.player.apples <= 0;
      els.modalAppleBtn.style.opacity = state.player.apples > 0 ? "1" : "0.5";

      els.modalStats.innerHTML = `
        <div class="stat-box">
          <div class="stat-label">HP</div>
          <div class="stat-value">${state.player.hp} / ${build.maxHp}</div>
        </div>
        <div class="stat-box">
          <div class="stat-label">Attack</div>
          <div class="stat-value">${build.attack}</div>
        </div>
        <div class="stat-box">
          <div class="stat-label">Armor</div>
          <div class="stat-value">${build.armor}</div>
        </div>
        <div class="stat-box">
          <div class="stat-label">Crit</div>
          <div class="stat-value">${Math.round(build.crit * 100)}%</div>
        </div>
        <div class="stat-box">
          <div class="stat-label">Dodge</div>
          <div class="stat-value">${Math.round(build.dodge * 100)}%</div>
        </div>
      `;

      els.equipmentGrid.innerHTML = Object.entries(slotMeta).map(([slot, meta]) => {
        const item = state.player.equipment[slot];
        if (!item) {
          return `
            <button class="equip-slot empty" type="button" data-slot="${slot}">
              <div class="slot-label">${meta.icon} ${meta.label}</div>
              <div class="slot-main">Empty</div>
              <div class="slot-desc">Tap backpack gear to equip.</div>
            </button>
          `;
        }

        return `
          <button class="equip-slot" type="button" data-slot="${slot}">
            <div class="slot-label">${meta.icon} ${meta.label}</div>
            <div class="slot-main">${item.icon} ${item.name}</div>
            <div class="slot-desc">${formatMods(item.mods)}<br>Tap to unequip.</div>
          </button>
        `;
      }).join("");

      if (!state.player.backpack.length) {
        els.backpackGrid.innerHTML = `<div class="empty-note">Backpack empty.</div>`;
      } else {
        els.backpackGrid.innerHTML = state.player.backpack.map((item) => `
          <button class="bag-item" type="button" data-item-id="${item.id}">
            <div class="item-action">${slotMeta[item.slot].icon} ${slotMeta[item.slot].label}</div>
            <div class="item-main">${item.icon} ${item.name}</div>
            <div class="item-desc">${formatMods(item.mods)}<br>Tap to equip.</div>
          </button>
        `).join("");
      }

      if (!state.passives.length) {
        els.passiveGrid.innerHTML = `<div class="empty-note">No blessings yet.</div>`;
      } else {
        els.passiveGrid.innerHTML = state.passives.map((item) => `
          <div class="bag-item" style="cursor:default;">
            <div class="item-action">Passive</div>
            <div class="item-main">${item.icon} ${item.name}</div>
            <div class="item-desc">${formatMods(item.mods)}</div>
          </div>
        `).join("");
      }

      els.equipmentGrid.querySelectorAll("[data-slot]").forEach((button) => {
        button.addEventListener("click", () => {
          const slot = button.dataset.slot;
          if (state.player.equipment[slot]) {
            unequipSlot(slot);
          }
        });
      });

      els.backpackGrid.querySelectorAll("[data-item-id]").forEach((button) => {
        button.addEventListener("click", () => {
          equipBackpackItem(Number(button.dataset.itemId));
        });
      });
    }

    function renderAll() {
      clampPlayerHp();
      renderHud();
      renderScene();
      renderPrompt();
      renderModal();
    }

    function refreshUiPanels() {
      clampPlayerHp();
      renderHud();
      renderScene();
      renderModal();
    }

    function nextQuestion(shouldRender = true) {
      if (state.player.hp <= 0) {
        gameOver();
        return;
      }

      state.mode = "quiz";
      state.currentEvent = null;
      state.hidePrompt = false;

      if (!state.questionDeck.length) {
        state.questionDeck = shuffle(questions);
      }

      state.currentQuestion = state.questionDeck.pop();

      if (shouldRender) {
        renderPrompt();
      }
    }

    function openEvent() {
      state.mode = "event";
      state.currentEvent = pick(eventDeck);
      state.hidePrompt = false;
      updateBanner("A strange encounter appears.");
      renderPrompt();
    }

    function openShop() {
      state.mode = "shop";
      state.currentShop = shuffle(shopPool).slice(0, 3);
      state.hidePrompt = false;
      state.lastMessage = "Buy gear, apples, or leave.";
      renderPrompt();
    }

    function maybeEncounter() {
      if (Math.random() < 0.32) {
        openShop();
        return true;
      }

      if (Math.random() < 0.68) {
        openEvent();
        return true;
      }

      return false;
    }

    function continueRunFlow() {
      if (state.player.hp <= 0) {
        gameOver();
        return;
      }

      if (state.pendingEnemyAdvance) {
        advanceToNextEnemy();
        return;
      }

      state.lock = false;
      nextQuestion();
    }

    function advanceToNextEnemy() {
      if (state.enemyIndex >= enemies.length - 1) {
        victory();
        return;
      }

      state.pendingEnemyAdvance = false;
      state.lock = true;
      state.mode = "quiz";
      state.currentEvent = null;
      state.currentShop = [];
      state.currentQuestion = null;
      state.hidePrompt = true;

      state.enemyIndex += 1;
      state.enemyHp = enemies[state.enemyIndex].hp;

      setEnemy(enemies[state.enemyIndex]);
      refreshUiPanels();

      setTimeout(() => {
        if (state.mode === "gameover" || state.mode === "victory") return;
        state.lock = false;
        nextQuestion();
      }, 640);
    }

    function createAnswerCard({
  value,
  tag = "",
  title = "",
  copy = "",
  glyph = "",
  layout = "default",
  hideTag = false
}) {
  const classes = value ? "play-card true-card" : "play-card false-card";
  const tilt = `${(Math.random() * 6 - 3).toFixed(2)}deg`;

  return `
    <button
      class="${classes} answer-canvas-card card-pre-enter"
      type="button"
      data-answer="${value}"
      data-tag="${tag}"
      data-title="${title}"
      data-copy="${copy}"
      data-glyph="${glyph}"
      data-layout="${layout}"
      data-hide-tag="${hideTag ? "true" : "false"}"
      style="--tilt:${tilt};"
    >
      <div class="answer-flip">
        <div class="answer-face answer-front-face">
          <canvas class="answer-front" width="360" height="504" aria-hidden="true"></canvas>
        </div>
        <div class="answer-face answer-back-face">
          <canvas class="answer-back-canvas" width="360" height="504" aria-hidden="true"></canvas>
        </div>
      </div>
      <canvas class="burn-canvas" width="360" height="504" aria-hidden="true"></canvas>
    </button>
  `;
}

    function createShopCard(item, index) {
      const tilt = `${(Math.random() * 6 - 3).toFixed(2)}deg`;

      return `
        <button class="play-card true-card card-pre-enter" type="button" data-shop-index="${index}" style="--tilt:${tilt};">
          <span class="card-corner">${item.icon}</span>
          <span class="card-corner bottom">${item.icon}</span>
          <span class="card-glyph">${item.icon}</span>
          <div class="card-body">
            <span class="card-tag">Shop</span>
            <h4 class="card-title">${item.name}</h4>
            <p class="card-copy">${item.desc}</p>
            <span class="card-price">🪙 ${item.cost}</span>
          </div>
        </button>
      `;
    }

    function createLeaveCard() {
      return `
        <button class="play-card false-card card-pre-enter" type="button" data-shop-index="leave" style="--tilt:0deg;">
          <span class="card-corner">🚪</span>
          <span class="card-corner bottom">🚪</span>
          <span class="card-glyph">🍂</span>
          <div class="card-body">
            <span class="card-tag">Leave</span>
            <h4 class="card-title">Leave Shop</h4>
            <p class="card-copy">Save your gold.</p>
          </div>
        </button>
      `;
    }

    function attachAnswerHandlers() {
      els.cardGrid.querySelectorAll("[data-answer]").forEach((btn) => {
        btn.addEventListener("click", () => {
          if (state.lock || state.mode !== "quiz") return;
          const guess = btn.dataset.answer === "true";
          resolveQuestion(guess, btn);
        });
      });
    }

    function attachEventHandlers() {
      els.cardGrid.querySelectorAll("[data-answer]").forEach((btn) => {
        btn.addEventListener("click", () => {
          if (state.lock || state.mode !== "event") return;
          const choice = btn.dataset.answer === "true";
          resolveEvent(choice, btn);
        });
      });
    }

    function attachShopHandlers() {
      els.cardGrid.querySelectorAll("[data-shop-index]").forEach((btn) => {
        btn.addEventListener("click", () => {
          if (state.lock || state.mode !== "shop") return;
          const value = btn.dataset.shopIndex;

          if (value === "leave") {
            state.lastMessage = "You leave the shop.";
            continueRunFlow();
            return;
          }

          const item = state.currentShop[Number(value)];
          buyItem(item);
        });
      });
    }

    async function resolveQuestion(guess, button) {
      state.lock = true;
      state.revealRunning = true;
      state.hidePrompt = true;

      const q = state.currentQuestion;
      const otherButton = [...els.cardGrid.querySelectorAll("[data-answer]")].find((node) => node !== button);
      const correct = guess === q.answer;

      if (correct) {
        state.combo += 1;
        const outcome = buildPlayerAttackOutcome();

        await runAnswerRevealStart({
          chosenButton: button,
          burnedButton: otherButton,
          title: outcome.card.title,
          copy: outcome.card.copy,
          tone: outcome.card.tone
        });

        await applyPlayerAttackOutcome(outcome);
        await wait(260);
        await finishAnswerReveal(button);

        state.revealRunning = false;

        if (state.mode === "victory") return;

        continueRunFlow();
        return;
      }

      state.combo = 0;
      const outcome = buildEnemyAttackOutcome();

      await runAnswerRevealStart({
        chosenButton: button,
        burnedButton: otherButton,
        title: outcome.card.title,
        copy: outcome.card.copy,
        tone: outcome.card.tone
      });

      await applyEnemyAttackOutcome(outcome);
      await wait(260);
      await finishAnswerReveal(button);

      state.revealRunning = false;

      if (state.player.hp <= 0) {
        gameOver();
        return;
      }

      continueRunFlow();
    }

    async function resolveEvent(choice, button) {
      state.lock = true;
      state.revealRunning = true;
      state.hidePrompt = true;

      const otherButton = [...els.cardGrid.querySelectorAll("[data-answer]")].find((node) => node !== button);
      const result = state.currentEvent.onChoose(choice, state);
      const choiceMeta = state.currentEvent.choices[String(choice)];
      clampPlayerHp();
      refreshUiPanels();

      await runAnswerRevealStart({
        chosenButton: button,
        burnedButton: otherButton,
        title: choiceMeta.title,
        copy: result,
        tone: "neutral"
      });

      await wait(820);
      await finishAnswerReveal(button);

      state.revealRunning = false;

      if (state.player.hp <= 0) {
        gameOver();
        return;
      }

      continueRunFlow();
    }

    function buyItem(item) {
      if (state.player.gold < item.cost) {
        state.lastMessage = "Not enough gold.";
        renderPrompt();
        return;
      }

      state.lock = true;
      state.player.gold -= item.cost;
      item.onBuy();
      clampPlayerHp();
      state.lastMessage = `Bought ${item.name}.`;
      renderAll();

      setTimeout(() => {
        continueRunFlow();
      }, 720);
    }

    function buildPlayerAttackOutcome() {
      const enemy = enemies[state.enemyIndex];
      const build = getPlayerBuild();
      const crit = Math.random() < build.crit;
      let damage = build.attack + Math.floor(Math.random() * 5);

      if (crit) damage = Math.round(damage * 1.75);
      if (state.combo >= 3) damage += 2;

      const nextEnemyHp = Math.max(0, state.enemyHp - damage);
      const defeated = nextEnemyHp <= 0;

      return {
        damage,
        crit,
        burstLabel: crit ? "CRIT!" : "HIT!",
        nextEnemyHp,
        defeated,
        rewardGold: defeated ? enemy.gold : 0,
        healAmount: defeated ? 8 : 0,
        card: {
          title: crit ? "Critical Hit" : "Correct",
          copy: defeated
            ? `You hit ${enemy.name} for ${damage} and finish it. +${enemy.gold} gold, +8 HP.`
            : `You hit ${enemy.name} for ${damage} damage. ${nextEnemyHp} HP remain.`,
          tone: "good"
        }
      };
    }

    async function applyPlayerAttackOutcome(outcome) {
      const enemy = enemies[state.enemyIndex];

      state.enemyHp = outcome.nextEnemyHp;
      renderScene();

      animateStrike("player", outcome.damage, outcome.burstLabel);
      await wait(700);

      if (!outcome.defeated) {
        refreshUiPanels();
        return;
      }

      state.player.gold += outcome.rewardGold;
      healPlayer(outcome.healAmount);
      spawnDamage("gold", `+${outcome.rewardGold} gold`, 72, 42);
      els.enemyFighter.classList.add("defeated");
      refreshUiPanels();

      await wait(260);

      state.pendingEnemyAdvance = true;

      if (state.enemyIndex >= enemies.length - 1) {
        victory();
      } else if (maybeEncounter()) {
        state.pendingEnemyAdvance = true;
      }
    }

    function buildEnemyAttackOutcome() {
      const enemy = enemies[state.enemyIndex];
      const build = getPlayerBuild();

      if (Math.random() < build.dodge) {
        return {
          dodged: true,
          playerDied: false,
          card: {
            title: "Wrong",
            copy: `${enemy.name} lunges, but you dodge the hit.`,
            tone: "bad"
          }
        };
      }

      const raw = enemy.attack + Math.floor(Math.random() * 4);
      const damage = Math.max(1, raw - build.armor);
      const nextPlayerHp = Math.max(0, state.player.hp - damage);

      return {
        dodged: false,
        damage,
        playerDied: nextPlayerHp <= 0,
        nextPlayerHp,
        card: {
          title: "Wrong",
          copy: nextPlayerHp > 0
            ? `${enemy.name} hits you for ${damage} damage. ${nextPlayerHp} HP left.`
            : `${enemy.name} hits you for ${damage} damage and drops you to 0 HP.`,
          tone: "bad"
        }
      };
    }

    async function applyEnemyAttackOutcome(outcome) {
      if (outcome.dodged) {
        animateDodge();
        await wait(720);
        refreshUiPanels();
        return;
      }

      takePlayerDamage(outcome.damage);
      animateStrike("enemy", outcome.damage, "OUCH");
      refreshUiPanels();

      await wait(760);
      refreshUiPanels();
    }

    function gameOver() {
      state.mode = "gameover";
      state.lock = false;
      state.hidePrompt = false;
      state.revealRunning = false;
      state.pendingEnemyAdvance = false;
      renderAll();
    }

    function victory() {
      state.mode = "victory";
      state.lock = false;
      state.hidePrompt = false;
      state.revealRunning = false;
      state.pendingEnemyAdvance = false;
      renderAll();
    }

    function animateStrike(side, damage, burstLabel) {
      const attacker = side === "player" ? els.playerFighter : els.enemyFighter;
      const defender = side === "player" ? els.enemyFighter : els.playerFighter;
      const slash = side === "player" ? els.playerSlash : els.enemySlash;

      attacker.classList.remove("attacking");
      defender.classList.remove("hit");
      slash.classList.remove("show");
      void attacker.offsetWidth;

      attacker.classList.add("attacking", side);
      defender.classList.add("hit");
      slash.textContent = side === "player" ? "✨" : "💥";
      slash.classList.add("show");

      const popX = side === "player" ? 76 : 22;
      const popY = 40;
      spawnDamage("bad", `-${damage}`, popX, popY);
      spawnDamage("good", burstLabel, side === "player" ? 67 : 30, 31, 0.78);

      setTimeout(() => {
        attacker.classList.remove("attacking");
        defender.classList.remove("hit");
        slash.classList.remove("show");
      }, 500);
    }

    function animateDodge() {
      spawnDamage("good", "DODGE", 24, 36, 0.95);
      els.playerFighter.style.transform = "translateX(-10px)";
      setTimeout(() => {
        els.playerFighter.style.transform = "";
      }, 220);
    }

    function spawnDamage(type, text, xPct, yPct, scale = 1) {
      const node = document.createElement("div");
      node.className = `damage-pop ${type}`;
      node.textContent = text;
      node.style.left = `${xPct}%`;
      node.style.top = `${yPct}%`;
      node.style.transform = `scale(${scale})`;
      els.damageLayer.appendChild(node);
      setTimeout(() => node.remove(), 1000);
    }

    function resetGame() {
      state.mode = "quiz";
      state.lock = false;
      state.modalOpen = false;
      state.revealRunning = false;
      state.hidePrompt = false;
      state.passives = [];
      state.enemyIndex = 0;
      state.enemyHp = enemies[0].hp;
      state.currentQuestion = null;
      state.currentEvent = null;
      state.currentShop = [];
      state.questionDeck = shuffle(questions);
      state.combo = 0;
      state.itemId = 0;
      state.pendingEnemyAdvance = false;
      state.lastMessage = "";

      state.player = {
        name: "Hero",
        emoji: "🧙",
        hp: 100,
        gold: 0,
        apples: 0,
        baseAttack: 8,
        baseArmor: 0,
        baseCrit: 0.08,
        baseDodge: 0.04,
        baseMaxHp: 100,
        equipment: {
          weapon: makeItem(itemDefs.starterWand),
          offhand: null,
          ring: null,
          boots: null,
          charm: null
        },
        backpack: []
      };

      els.cardGrid.style.height = "";
      closeModal();
      setEnemy(enemies[state.enemyIndex], true);
      nextQuestion(false);
      renderAll();
    }

    function roundRectPath(ctx, x, y, w, h, r) {
      const rr = Math.min(r, w * 0.5, h * 0.5);
      ctx.beginPath();
      ctx.moveTo(x + rr, y);
      ctx.arcTo(x + w, y, x + w, y + h, rr);
      ctx.arcTo(x + w, y + h, x, y + h, rr);
      ctx.arcTo(x, y + h, x, y, rr);
      ctx.arcTo(x, y, x + w, y, rr);
      ctx.closePath();
    }

    function drawAnswerCardFace(canvas, options) {
      const ctx = canvas.getContext("2d", { alpha: true });
      const W = canvas.width;
      const H = canvas.height;

      const palette = options.truthy
        ? {
            glow: "rgba(97, 246, 181, 0.30)",
            soft: "rgba(97, 246, 181, 0.10)",
            bright: "#aaffdf"
          }
        : {
            glow: "rgba(255, 122, 145, 0.32)",
            soft: "rgba(255, 122, 145, 0.10)",
            bright: "#ffd1da"
          };

      ctx.clearRect(0, 0, W, H);

      const outerGrad = ctx.createLinearGradient(0, 0, 0, H);
      outerGrad.addColorStop(0, "#20295a");
      outerGrad.addColorStop(0.48, "#111734");
      outerGrad.addColorStop(1, "#090e22");

      roundRectPath(ctx, 1, 1, W - 2, H - 2, 28);
      ctx.fillStyle = outerGrad;
      ctx.fill();

      const glow = ctx.createRadialGradient(W * 0.74, H * 0.14, 10, W * 0.5, H * 0.28, W * 0.78);
      glow.addColorStop(0, palette.glow);
      glow.addColorStop(0.35, palette.soft);
      glow.addColorStop(1, "rgba(0,0,0,0)");
      ctx.fillStyle = glow;
      roundRectPath(ctx, 1, 1, W - 2, H - 2, 28);
      ctx.fill();

      ctx.strokeStyle = "rgba(255,255,255,0.11)";
      ctx.lineWidth = 1.25;
      roundRectPath(ctx, 1.5, 1.5, W - 3, H - 3, 28);
      ctx.stroke();

      ctx.strokeStyle = "rgba(255,255,255,0.05)";
      roundRectPath(ctx, 14.5, 14.5, W - 29, H - 29, 20);
      ctx.stroke();

      ctx.save();
      roundRectPath(ctx, 14, 14, W - 28, H - 28, 20);
      ctx.clip();

      const diagonal = ctx.createLinearGradient(0, 0, W, H);
      diagonal.addColorStop(0, "rgba(255,255,255,0.01)");
      diagonal.addColorStop(0.45, palette.soft);
      diagonal.addColorStop(1, "rgba(255,255,255,0.01)");
      ctx.strokeStyle = diagonal;
      ctx.lineWidth = 28;
      ctx.beginPath();
      ctx.moveTo(48, 122);
      ctx.bezierCurveTo(118, 72, 198, 176, 304, 108);
      ctx.stroke();

      for (let i = 0; i < 110; i += 1) {
        const x = Math.random() * W;
        const y = Math.random() * H;
        const r = Math.random() * 1.2 + 0.25;
        const a = Math.random() * 0.055;
        ctx.fillStyle = `rgba(255,255,255,${a})`;
        ctx.beginPath();
        ctx.arc(x, y, r, 0, Math.PI * 2);
        ctx.fill();
      }

      ctx.restore();

      ctx.strokeStyle = "rgba(255,255,255,0.05)";
      ctx.beginPath();
      ctx.moveTo(34, 52);
      ctx.lineTo(W - 34, 52);
      ctx.moveTo(34, H - 52);
      ctx.lineTo(W - 34, H - 52);
      ctx.stroke();

      ctx.fillStyle = palette.bright;
      ctx.font = "800 24px Inter, system-ui, sans-serif";
      ctx.textBaseline = "top";
      ctx.textAlign = "left";
      ctx.fillText(options.glyph, 24, 22);

      ctx.save();
      ctx.translate(W - 24, H - 22);
      ctx.rotate(Math.PI);
      ctx.textAlign = "right";
      ctx.fillText(options.glyph, 0, 0);
      ctx.restore();

      const centerGlow = ctx.createRadialGradient(W * 0.5, H * 0.34, 0, W * 0.5, H * 0.34, 118);
      centerGlow.addColorStop(0, palette.glow);
      centerGlow.addColorStop(0.4, palette.soft);
      centerGlow.addColorStop(1, "rgba(0,0,0,0)");
      ctx.fillStyle = centerGlow;
      ctx.beginPath();
      ctx.arc(W * 0.5, H * 0.35, 118, 0, Math.PI * 2);
      ctx.fill();

      ctx.strokeStyle = "rgba(255,255,255,0.08)";
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.arc(W * 0.5, H * 0.35, 94, 0, Math.PI * 2);
      ctx.stroke();

      ctx.strokeStyle = palette.soft;
      ctx.beginPath();
      ctx.arc(W * 0.5, H * 0.35, 72, 0, Math.PI * 2);
      ctx.stroke();

      ctx.fillStyle = "rgba(255,255,255,0.12)";
      ctx.font = "900 136px Inter, system-ui, sans-serif";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      ctx.fillText(options.glyph, W * 0.5, H * 0.37);

      if (options.layout === "event") {
        ctx.fillStyle = "#f1f5ff";
        ctx.font = "900 30px Inter, system-ui, sans-serif";
        ctx.textAlign = "left";
        ctx.textBaseline = "top";
        wrapCanvasText(ctx, options.title, 26, 72, W - 52, 30);

        ctx.strokeStyle = "rgba(255,255,255,0.08)";
        ctx.beginPath();
        ctx.moveTo(26, H - 112);
        ctx.lineTo(W - 26, H - 112);
        ctx.stroke();

        ctx.fillStyle = "rgba(221,228,255,0.84)";
        ctx.font = "500 18px Inter, system-ui, sans-serif";
        ctx.textBaseline = "top";
        wrapCanvasText(ctx, options.copy, 26, H - 96, W - 52, 22);
        return;
      }

      if (!options.hideTag && options.tag) {
        const pillX = 26;
        const pillY = H - 150;
        const pillW = Math.max(92, Math.min(132, 44 + options.tag.length * 9));
        const pillH = 34;

        roundRectPath(ctx, pillX, pillY, pillW, pillH, 999);
        ctx.fillStyle = "rgba(255,255,255,0.06)";
        ctx.fill();
        ctx.strokeStyle = "rgba(255,255,255,0.10)";
        ctx.stroke();

        ctx.fillStyle = "#f7fbff";
        ctx.font = "700 13px Inter, system-ui, sans-serif";
        ctx.textAlign = "left";
        ctx.textBaseline = "middle";
        ctx.fillText(options.tag, pillX + 14, pillY + pillH * 0.52);
      }

      ctx.textAlign = "left";
      ctx.textBaseline = "top";

      ctx.fillStyle = "#f1f5ff";
      ctx.font = "900 38px Inter, system-ui, sans-serif";
      wrapCanvasText(ctx, options.title, 26, H - 110, W - 52, 34);

      ctx.fillStyle = "rgba(221,228,255,0.78)";
      ctx.font = "500 18px Inter, system-ui, sans-serif";
      wrapCanvasText(ctx, options.copy, 26, H - 62, W - 52, 22);

      const edgeGlow = ctx.createLinearGradient(0, 0, W, 0);
      edgeGlow.addColorStop(0, "rgba(255,255,255,0)");
      edgeGlow.addColorStop(0.5, palette.soft);
      edgeGlow.addColorStop(1, "rgba(255,255,255,0)");
      ctx.strokeStyle = edgeGlow;
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(28, H - 182);
      ctx.lineTo(W - 28, H - 182);
      ctx.stroke();
    }

    function drawResultCardFace(canvas, result) {
      const ctx = canvas.getContext("2d", { alpha: true });
      const W = canvas.width;
      const H = canvas.height;

      const palettes = {
        good: {
          glow: "rgba(97, 246, 181, 0.24)",
          soft: "rgba(97, 246, 181, 0.10)",
          border: "rgba(97, 246, 181, 0.24)",
          top: "rgba(21, 53, 55, 0.98)",
          bottom: "rgba(8, 18, 24, 0.98)",
          glyph: "✦"
        },
        bad: {
          glow: "rgba(255, 122, 145, 0.24)",
          soft: "rgba(255, 122, 145, 0.10)",
          border: "rgba(255, 122, 145, 0.24)",
          top: "rgba(54, 26, 38, 0.98)",
          bottom: "rgba(22, 10, 17, 0.98)",
          glyph: "✕"
        },
        neutral: {
          glow: "rgba(118, 231, 255, 0.22)",
          soft: "rgba(118, 231, 255, 0.10)",
          border: "rgba(118, 231, 255, 0.22)",
          top: "rgba(20, 34, 58, 0.98)",
          bottom: "rgba(9, 14, 26, 0.98)",
          glyph: "✦"
        }
      };

      const palette = palettes[result.tone] || palettes.neutral;

      ctx.clearRect(0, 0, W, H);

      const bg = ctx.createLinearGradient(0, 0, 0, H);
      bg.addColorStop(0, palette.top);
      bg.addColorStop(1, palette.bottom);

      roundRectPath(ctx, 1, 1, W - 2, H - 2, 28);
      ctx.fillStyle = bg;
      ctx.fill();

      const glow = ctx.createRadialGradient(W * 0.5, H * 0.14, 0, W * 0.5, H * 0.14, W * 0.72);
      glow.addColorStop(0, palette.glow);
      glow.addColorStop(0.38, palette.soft);
      glow.addColorStop(1, "rgba(0,0,0,0)");
      ctx.fillStyle = glow;
      roundRectPath(ctx, 1, 1, W - 2, H - 2, 28);
      ctx.fill();

      ctx.strokeStyle = palette.border;
      ctx.lineWidth = 1.25;
      roundRectPath(ctx, 1.5, 1.5, W - 3, H - 3, 28);
      ctx.stroke();

      ctx.strokeStyle = "rgba(255,255,255,0.06)";
      roundRectPath(ctx, 14.5, 14.5, W - 29, H - 29, 20);
      ctx.stroke();

      ctx.fillStyle = "rgba(255,255,255,0.09)";
      ctx.font = "900 134px Inter, system-ui, sans-serif";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      ctx.fillText(palette.glyph, W * 0.5, H * 0.34);

      const lineGlow = ctx.createLinearGradient(0, 0, W, 0);
      lineGlow.addColorStop(0, "rgba(255,255,255,0)");
      lineGlow.addColorStop(0.5, palette.soft);
      lineGlow.addColorStop(1, "rgba(255,255,255,0)");
      ctx.strokeStyle = lineGlow;
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(28, H - 186);
      ctx.lineTo(W - 28, H - 186);
      ctx.stroke();

      ctx.fillStyle = "#f5f7ff";
      ctx.textAlign = "left";
      ctx.textBaseline = "top";
      ctx.font = "900 38px Inter, system-ui, sans-serif";
      wrapCanvasText(ctx, result.title || "", 26, H - 150, W - 52, 36);

      ctx.fillStyle = "rgba(236,241,255,0.84)";
      ctx.font = "500 18px Inter, system-ui, sans-serif";
      wrapCanvasText(ctx, result.copy || "", 26, H - 96, W - 52, 23);
    }

    function wrapCanvasText(ctx, text, x, y, maxWidth, lineHeight) {
      const words = text.split(" ");
      let line = "";
      let currentY = y;

      for (let i = 0; i < words.length; i += 1) {
        const testLine = line ? `${line} ${words[i]}` : words[i];
        const metrics = ctx.measureText(testLine);

        if (metrics.width > maxWidth && line) {
          ctx.fillText(line, x, currentY);
          line = words[i];
          currentY += lineHeight;
        } else {
          line = testLine;
        }
      }

      if (line) {
        ctx.fillText(line, x, currentY);
      }
    }

    function paintAnswerCardCanvases() {
      els.cardGrid.querySelectorAll(".answer-canvas-card").forEach((button) => {
        const canvas = button.querySelector(".answer-front");
        drawAnswerCardFace(canvas, {
          truthy: button.dataset.answer === "true",
          tag: button.dataset.tag || "",
          title: button.dataset.title || "",
          copy: button.dataset.copy || "",
          glyph: button.dataset.glyph || "",
          layout: button.dataset.layout || "default",
          hideTag: button.dataset.hideTag === "true"
        });
      });
    }

    function setResultFace(button, result) {
  button.classList.remove("result-good", "result-bad", "result-neutral");
  button.classList.add(`result-${result.tone}`);

  button.__resultFace = {
    title: result.title,
    copy: result.copy,
    tone: result.tone
  };

  const backCanvas = button.querySelector(".answer-back-canvas");
  if (backCanvas) {
    drawResultCardFace(backCanvas, button.__resultFace);
  }
}

function animateFreshCards() {
  const cards = [...els.cardGrid.querySelectorAll(".card-pre-enter")];
  if (!cards.length) return;

  cards.forEach((card, index) => {
    card.style.transitionDelay = `${index * 70}ms`;
  });

  void els.cardGrid.offsetWidth;

  requestAnimationFrame(() => {
    cards.forEach((card) => {
      card.classList.add("card-enter-active");

      card.addEventListener("transitionend", () => {
        card.classList.remove("card-pre-enter", "card-enter-active");
        card.style.transitionDelay = "";
        card.style.pointerEvents = "";
      }, { once: true });
    });
  });
}

    function cleanupFloatingCard(button) {
      if (button.__placeholder) {
        button.__placeholder.remove();
        button.__placeholder = null;
      }
    }

    async function runAnswerRevealStart({ chosenButton, burnedButton, title, copy, tone }) {
      const gridRect = els.cardGrid.getBoundingClientRect();
      els.cardGrid.style.height = `${gridRect.height}px`;
      els.cardGrid.classList.add("is-animating");

      setResultFace(chosenButton, { title, copy, tone });
      chosenButton.classList.add("is-selected");

      const burnPromise = burnedButton ? burnAwayCard(burnedButton, "front") : Promise.resolve();
      const flipPromise = floatAndFlipCard(chosenButton, 240);

      await Promise.all([burnPromise, flipPromise]);

      if (burnedButton) {
        burnedButton.style.visibility = "hidden";
      }
    }

    async function finishAnswerReveal(chosenButton) {
      await burnAwayCard(chosenButton, "result");
      cleanupFloatingCard(chosenButton);
      els.cardGrid.innerHTML = "";
      els.cardGrid.style.height = "";
      els.cardGrid.classList.remove("is-animating");
    }

    async function floatAndFlipCard(button, delayBeforeMove = 240) {
      const rect = button.getBoundingClientRect();
      const gridRect = els.cardGrid.getBoundingClientRect();

      const dx = gridRect.left + gridRect.width / 2 - (rect.left + rect.width / 2);
      const dy = gridRect.top + gridRect.height / 2 - (rect.top + rect.height / 2);
      const scale = window.innerWidth > 760 ? 1.08 : 1.03;

      const placeholder = document.createElement("div");
      placeholder.className = "card-placeholder";
      placeholder.style.height = `${rect.height}px`;

      button.parentNode.insertBefore(placeholder, button);
      button.__placeholder = placeholder;

      button.classList.add("floating-card");
      button.style.setProperty("--tilt", "0deg");
      button.style.position = "fixed";
      button.style.left = `${rect.left}px`;
      button.style.top = `${rect.top}px`;
      button.style.width = `${rect.width}px`;
      button.style.height = `${rect.height}px`;
      button.style.margin = "0";
      button.style.zIndex = "45";
      button.style.pointerEvents = "none";
      button.style.transform = "translate3d(0, 0, 0) scale(1)";

      await wait(delayBeforeMove);

      requestAnimationFrame(() => {
        button.classList.add("is-flipped");
        button.style.transform = `translate3d(${dx}px, ${dy}px, 0) scale(${scale})`;
      });

      await wait(800);
    }

    function makeRadialSprite(size, stops) {
      const c = document.createElement("canvas");
      c.width = size;
      c.height = size;
      const gctx = c.getContext("2d");
      const g = gctx.createRadialGradient(size * 0.5, size * 0.5, 0, size * 0.5, size * 0.5, size * 0.5);

      for (const stop of stops) {
        g.addColorStop(stop[0], stop[1]);
      }

      gctx.fillStyle = g;
      gctx.beginPath();
      gctx.arc(size * 0.5, size * 0.5, size * 0.5, 0, Math.PI * 2);
      gctx.fill();
      return c;
    }

    const burnAssets = (() => {
      let cached = null;

      return () => {
        if (cached) return cached;

        cached = {
          smoke: makeRadialSprite(128, [
            [0.0, "rgba(150,150,150,0.22)"],
            [0.45, "rgba(95,95,95,0.12)"],
            [1.0, "rgba(30,30,30,0)"]
          ]),
          ember: makeRadialSprite(96, [
            [0.0, "rgba(255,242,180,1)"],
            [0.25, "rgba(255,170,72,0.92)"],
            [0.68, "rgba(255,90,20,0.28)"],
            [1.0, "rgba(255,60,10,0)"]
          ])
        };

        return cached;
      };
    })();

    function smoothstep(t) {
      return t * t * (3 - 2 * t);
    }

    function lerp(a, b, t) {
      return a + (b - a) * t;
    }

    function rand(min, max) {
      return min + Math.random() * (max - min);
    }

    function makeValueNoise2D(w, h, cell) {
      const gw = Math.ceil(w / cell) + 3;
      const gh = Math.ceil(h / cell) + 3;
      const grid = new Float32Array(gw * gh);

      for (let i = 0; i < grid.length; i += 1) {
        grid[i] = Math.random() * 2 - 1;
      }

      const out = new Float32Array(w * h);

      for (let y = 0; y < h; y += 1) {
        const gy = y / cell;
        const iy = Math.floor(gy);
        const ty = smoothstep(gy - iy);

        for (let x = 0; x < w; x += 1) {
          const gx = x / cell;
          const ix = Math.floor(gx);
          const tx = smoothstep(gx - ix);

          const g00 = grid[iy * gw + ix];
          const g10 = grid[iy * gw + ix + 1];
          const g01 = grid[(iy + 1) * gw + ix];
          const g11 = grid[(iy + 1) * gw + ix + 1];

          const a = lerp(g00, g10, tx);
          const b = lerp(g01, g11, tx);
          out[y * w + x] = lerp(a, b, ty);
        }
      }

      return out;
    }

    function makeValueNoise1D(w, cell) {
      const gw = Math.ceil(w / cell) + 3;
      const grid = new Float32Array(gw);

      for (let i = 0; i < gw; i += 1) {
        grid[i] = Math.random() * 2 - 1;
      }

      const out = new Float32Array(w);

      for (let x = 0; x < w; x += 1) {
        const gx = x / cell;
        const ix = Math.floor(gx);
        const tx = smoothstep(gx - ix);
        out[x] = lerp(grid[ix], grid[ix + 1], tx);
      }

      return out;
    }

    function makeBurnAnimator(sourceCanvas, targetCanvas) {
      const ctx = targetCanvas.getContext("2d", { alpha: true, desynchronized: true });
      const W = sourceCanvas.width;
      const H = sourceCanvas.height;

      const sourceCtx = sourceCanvas.getContext("2d", { alpha: true });
      const sourceImageData = sourceCtx.getImageData(0, 0, W, H);
      const sourcePixels = sourceImageData.data;

      const frameImageData = ctx.createImageData(W, H);
      const framePixels = frameImageData.data;

      const assets = burnAssets();
      const smokeSprite = assets.smoke;
      const emberGlowSprite = assets.ember;

      const frontierMap = new Float32Array(W);

      let progress = 0;
      let ç = true;
      let done = false;
      let lastTime = 0;
      let floatT = 0;

      let embers = [];
      let smoke = [];

      let noiseCombined = null;
      let columnNoiseA = null;
      let columnNoiseB = null;
      let profile = null;

      function clampNumber(v, min, max) {
        return Math.max(min, Math.min(max, v));
      }

      function buildProfile() {
        profile = {
          cellLarge: rand(46, 70),
          cellMain: rand(22, 38),
          cellDetail: rand(8, 16),
          columnCellA: rand(18, 34),
          columnCellB: rand(42, 76),
          largeAmp: rand(18, 34),
          mainAmp: rand(10, 20),
          detailAmp: rand(4, 11),
          edgeAmpA: rand(5, 18),
          edgeAmpB: rand(3, 12),
          edgeAmpC: rand(2, 8),
          freqA: rand(0.030, 0.085),
          freqB: rand(0.010, 0.032),
          freqC: rand(0.090, 0.220),
          speedA: rand(0.0030, 0.0080),
          speedB: rand(0.0016, 0.0048),
          speedC: rand(0.0080, 0.0200),
          phaseA: rand(0, Math.PI * 2),
          phaseB: rand(0, Math.PI * 2),
          phaseC: rand(0, Math.PI * 2),
          columnAmpA: rand(12, 28),
          columnAmpB: rand(8, 18),
          slant: rand(-0.18, 0.18),
          bow: rand(-20, 20),
          glowBand: rand(14, 22),
          charBand: rand(28, 42),
          emberBurst: rand(0.85, 1.35),
          flameBoost: rand(0.90, 1.35)
        };

        const noiseLarge = makeValueNoise2D(W, H, profile.cellLarge);
        const noiseMain = makeValueNoise2D(W, H, profile.cellMain);
        const noiseDetail = makeValueNoise2D(W, H, profile.cellDetail);

        noiseCombined = new Float32Array(W * H);

        for (let i = 0; i < noiseCombined.length; i += 1) {
          noiseCombined[i] =
            noiseLarge[i] * profile.largeAmp +
            noiseMain[i] * profile.mainAmp +
            noiseDetail[i] * profile.detailAmp;
        }

        columnNoiseA = makeValueNoise1D(W, profile.columnCellA);
        columnNoiseB = makeValueNoise1D(W, profile.columnCellB);
      }

      function getFrontierY(x, t) {
        const nx = x / (W - 1);
        const center = nx - 0.5;

        const base = H + 44 - progress * (H + 92);
        const slant = center * profile.slant * H;
        const bow = profile.bow * (1 - Math.abs(center) * 2);

        const wobbleA = Math.sin(t * profile.speedA + x * profile.freqA + profile.phaseA) * profile.edgeAmpA;
        const wobbleB = Math.sin(t * profile.speedB + x * profile.freqB + profile.phaseB) * profile.edgeAmpB;
        const wobbleC = Math.sin(t * profile.speedC + x * profile.freqC + profile.phaseC) * profile.edgeAmpC;

        const noiseWiggle = columnNoiseA[x] * profile.columnAmpA + columnNoiseB[x] * profile.columnAmpB;

        return base + slant + bow + wobbleA + wobbleB + wobbleC + noiseWiggle;
      }

      function updateFrontierMap(t) {
        for (let x = 0; x < W; x += 1) {
          frontierMap[x] = getFrontierY(x, t);
        }
      }

      function spawnParticles() {
        if (!burning || done) return;

        const count = Math.max(3, Math.round((4 + progress * 5) * profile.emberBurst));

        for (let i = 0; i < count; i += 1) {
          const x = Math.random() * W;
          const y = frontierMap[x | 0];

          if (y < -15 || y > H + 10) continue;

          embers.push({
            x: x + (Math.random() - 0.5) * 6,
            y: y + (Math.random() - 0.5) * 4,
            vx: (Math.random() - 0.5) * 0.75,
            vy: -0.8 - Math.random() * 2.3,
            size: 1 + Math.random() * 2.2,
            life: 20 + Math.random() * 24,
            maxLife: 20 + Math.random() * 24,
            glow: Math.random() * 0.6 + 0.4
          });

          if (Math.random() < 0.14) {
            smoke.push({
              x: x + (Math.random() - 0.5) * 8,
              y: y - 2,
              vx: (Math.random() - 0.5) * 0.28,
              vy: -0.15 - Math.random() * 0.45,
              size: 7 + Math.random() * 8,
              grow: 0.10 + Math.random() * 0.15,
              life: 24 + Math.random() * 30,
              maxLife: 24 + Math.random() * 30
            });
          }
        }
      }

      function updateParticles(dt) {
        const step = dt * 0.06;

        for (let i = embers.length - 1; i >= 0; i -= 1) {
          const p = embers[i];
          p.x += p.vx * step;
          p.y += p.vy * step;
          p.vy += 0.01 * step;
          p.life -= step;
          if (p.life <= 0) embers.splice(i, 1);
        }

        for (let i = smoke.length - 1; i >= 0; i -= 1) {
          const p = smoke[i];
          p.x += p.vx * step;
          p.y += p.vy * step;
          p.size += p.grow * step;
          p.life -= step;
          if (p.life <= 0) smoke.splice(i, 1);
        }
      }

      function drawSmoke() {
        ctx.save();
        ctx.globalCompositeOperation = "source-over";

        for (const p of smoke) {
          const alpha = clampNumber(p.life / p.maxLife, 0, 1) * 0.7;
          const d = p.size * 2;
          ctx.globalAlpha = alpha;
          ctx.drawImage(smokeSprite, p.x - p.size, p.y - p.size, d, d);
        }

        ctx.restore();
        ctx.globalAlpha = 1;
      }

      function drawEmbers() {
        ctx.save();
        ctx.globalCompositeOperation = "screen";

        for (const p of embers) {
          const life = clampNumber(p.life / p.maxLife, 0, 1);
          const glow = p.size * (2.2 + p.glow * 1.5);
          const d = glow * 2;

          ctx.globalAlpha = life * 0.95;
          ctx.drawImage(emberGlowSprite, p.x - glow, p.y - glow, d, d);

          ctx.globalAlpha = life * 0.85;
          ctx.fillStyle = "rgba(255,245,220,1)";
          ctx.beginPath();
          ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
          ctx.fill();
        }

        ctx.restore();
        ctx.globalAlpha = 1;
      }

      function drawFlameFront(t) {
        if (progress <= 0 || done) return;

        const points = [];
        for (let x = 0; x <= W; x += 8) {
          points.push([x, frontierMap[Math.min(W - 1, x)]]);
        }

        ctx.save();
        ctx.globalCompositeOperation = "screen";

        ctx.beginPath();
        ctx.moveTo(points[0][0], points[0][1]);
        for (let i = 1; i < points.length; i += 1) {
          ctx.lineTo(points[i][0], points[i][1]);
        }

        ctx.lineWidth = 16;
        ctx.strokeStyle = "rgba(255, 94, 26, 0.14)";
        ctx.shadowBlur = 18;
        ctx.shadowColor = "rgba(255, 94, 26, 0.34)";
        ctx.stroke();

        ctx.beginPath();
        ctx.moveTo(points[0][0], points[0][1]);
        for (let i = 1; i < points.length; i += 1) {
          ctx.lineTo(points[i][0], points[i][1]);
        }

        ctx.lineWidth = 6;
        ctx.strokeStyle = "rgba(255, 182, 73, 0.38)";
        ctx.shadowBlur = 10;
        ctx.shadowColor = "rgba(255, 174, 51, 0.28)";
        ctx.stroke();

        ctx.shadowBlur = 0;

        for (let x = 0; x < W; x += 24) {
          const y = frontierMap[x];
          if (y < -20 || y > H + 10) continue;

          const flameH = (
            8 +
            (Math.sin(t * 0.02 + x * 0.31 + profile.phaseA) * 0.5 + 0.5) * 12 +
            progress * 8
          ) * profile.flameBoost;

          const flameW = 5 + (Math.sin(t * 0.017 + x * 0.12 + profile.phaseB) * 0.5 + 0.5) * 4;

          ctx.fillStyle = "rgba(255, 128, 46, 0.34)";
          ctx.beginPath();
          ctx.moveTo(x - flameW, y + 2);
          ctx.quadraticCurveTo(x - flameW * 0.2, y - flameH * 0.6, x, y - flameH);
          ctx.quadraticCurveTo(x + flameW * 0.2, y - flameH * 0.55, x + flameW, y + 2);
          ctx.closePath();
          ctx.fill();

          ctx.fillStyle = "rgba(255, 214, 120, 0.22)";
          ctx.beginPath();
          ctx.moveTo(x - flameW * 0.45, y + 1);
          ctx.quadraticCurveTo(x - flameW * 0.1, y - flameH * 0.48, x, y - flameH * 0.72);
          ctx.quadraticCurveTo(x + flameW * 0.1, y - flameH * 0.46, x + flameW * 0.45, y + 1);
          ctx.closePath();
          ctx.fill();
        }

        ctx.restore();
      }

      function renderBurnFrame() {
        framePixels.fill(0);

        for (let y = 0; y < H; y += 1) {
          const row = y * W;

          for (let x = 0; x < W; x += 1) {
            const pixelIndex = row + x;
            const i = pixelIndex * 4;
            const alpha = sourcePixels[i + 3];

            if (alpha === 0) continue;

            const field = y - frontierMap[x] + noiseCombined[pixelIndex];

            if (field > 0) {
              continue;
            }

            let r = sourcePixels[i];
            let g = sourcePixels[i + 1];
            let b = sourcePixels[i + 2];
            let a = alpha;

            if (field > -profile.glowBand) {
              const edge = 1 - clampNumber((-field) / profile.glowBand, 0, 1);
              const glow = Math.pow(edge, 0.85);

              r = r * (1 - glow * 0.82) + 255 * glow * 0.95;
              g = g * (1 - glow * 0.88) + 138 * glow * 0.55;
              b = b * (1 - glow * 0.95) + 34 * glow * 0.18;
              a = a * (1 - glow * 0.15);
            } else if (field > -profile.charBand) {
              const charAmt = 1 - clampNumber(((-field) - profile.glowBand) / (profile.charBand - profile.glowBand), 0, 1);
              r *= 1 - charAmt * 0.18;
              g *= 1 - charAmt * 0.22;
              b *= 1 - charAmt * 0.28;
            }

            framePixels[i] = r;
            framePixels[i + 1] = g;
            framePixels[i + 2] = b;
            framePixels[i + 3] = a;
          }
        }

        ctx.clearRect(0, 0, W, H);
        ctx.putImageData(frameImageData, 0, 0);
      }

      return {
        start() {
          buildProfile();

          return new Promise((resolve) => {
            function loop(now) {
              const dt = Math.min(32, now - lastTime || 16.67);
              lastTime = now;
              floatT += dt;

              if (burning && !done) {
                progress += dt * 0.00142;

                if (progress >= 1.08) {
                  progress = 1.08;
                  burning = false;
                  done = true;
                }
              }

              updateFrontierMap(floatT);
              spawnParticles();
              updateParticles(dt);
              renderBurnFrame();
              drawSmoke();
              drawFlameFront(floatT);
              drawEmbers();

              if (burning || embers.length > 0 || smoke.length > 0) {
                requestAnimationFrame(loop);
              } else {
                ctx.clearRect(0, 0, W, H);
                resolve();
              }
            }

            lastTime = performance.now();
            requestAnimationFrame(loop);
          });
        }
      };
    }

    function cloneCanvasElement(sourceCanvas) {
      const copy = document.createElement("canvas");
      copy.width = sourceCanvas.width;
      copy.height = sourceCanvas.height;

      const copyCtx = copy.getContext("2d", { alpha: true });
      copyCtx.clearRect(0, 0, copy.width, copy.height);
      copyCtx.drawImage(sourceCanvas, 0, 0);

      return copy;
    }

    function makeBurnSourceCanvas(button, sourceType) {
  if (sourceType === "result") {
    const liveResultCanvas = button.querySelector(".answer-back-canvas");

    if (liveResultCanvas) {
      return cloneCanvasElement(liveResultCanvas);
    }

    const c = document.createElement("canvas");
    c.width = 360;
    c.height = 504;
    drawResultCardFace(c, button.__resultFace || {
      title: "Result",
      copy: "",
      tone: "neutral"
    });
    return c;
  }

  return cloneCanvasElement(button.querySelector(".answer-front"));
}

async function burnAwayCard(button, sourceType = "front") {
  const burnCanvas = button.querySelector(".burn-canvas");
  const burnCtx = burnCanvas.getContext("2d", { alpha: true });
  const sourceCanvas = makeBurnSourceCanvas(button, sourceType);

  burnCanvas.width = sourceCanvas.width;
  burnCanvas.height = sourceCanvas.height;

  burnCtx.clearRect(0, 0, burnCanvas.width, burnCanvas.height);
  burnCtx.drawImage(sourceCanvas, 0, 0);

  burnCanvas.style.opacity = "1";

  await new Promise((resolve) => requestAnimationFrame(resolve));

  button.classList.add("is-burning");

  const animator = makeBurnAnimator(sourceCanvas, burnCanvas);
  await animator.start();
}

    els.avatarBtn.addEventListener("click", openModal);
    els.closeModalBtn.addEventListener("click", closeModal);
    els.modalAppleBtn.addEventListener("click", eatApple);

    els.modalBackdrop.addEventListener("click", (event) => {
      if (event.target === els.modalBackdrop) {
        closeModal();
      }
    });

    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape" && state.modalOpen) {
        closeModal();
      }
    });

    resetGame();