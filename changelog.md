# Noobs of Iron Changelog

## General changes
- **All resources are multiplied by x12** (production and consumption alike) across the board
- Special Forces battalions require support equipment
- **Special forces cap heavily reduced** (0.05 to 0.008 base)
- Logistics company technology gives access to fuel support company, which **increases fuel capacity and decreases fuel consumption**. Regular logistics company no longer decreases fuel consumption
- Salvador has been nuked of its ressources and manpower for performance reason
- **Ahistorical focus branches** are gated behind a game rule toggle (disabled by default)
- **Host tool** system for multiplayer/tournament play (allows selecting a host country for special modifiers)

### Fuel rebalance
- Oil-to-fuel conversion drastically reduced (2 to 0.17)
- Fuel capacity quintupled (50k to 250k)
- Army fuel consumption increased (0.5 to 0.70)

### Defines & economy
- Max political power cap increased (2000 to 20000)
- Command power ceiling raised (80 to 120)
- Base research points increased (30 to 50 per slot)
- Airbase capacity halved (200 to 100 per level)
- Volunteer division requirement halved (30 to 15)
- Embargo cost reduced (100 to 50)
- Dockyard base cost reduced (12000 to 8000)
- CIC contract allocation massively expanded (15 to 150 factories per contract)

### Map
- **Gibraltar is now impassable**
- North African desert provinces reclassified as **deep desert** (~30 provinces)
- New strategic regions: **Cyrenaica**, **Upper Egypt**, **Tunis** (split from vanilla North Africa)
- New provinces added in desert regions

### Balance changes
#### Tanks
- HV cannons are more expensive
- Regular cannons are better
- HW are better but cant be put on turrets anymore
- SPGs are 2w now
- TDs got nerfed to hell and back (reduced breakthrough and soft attack)
- Armor types have been balanced
- New apcr and aphe rounds (via special project)
#### Planes
- Jet engines range penalty has been massively reduced, and the agility buffs is doubled
#### Doctrines
- Human wave offensive brings less recrutable pop and reduced infantry health
- Land doctrine research multiplier vastly increased (4x to 20x)
- Mobile Warfare attacker bonus increased (+25% to +35%), defender penalty increased (-15% to -25%)
- Sprinkles here and there
#### Combat
- Core territory bonuses halved
- Paradrop penalties harsher (less org on landing, longer penalty duration)
- Encircled units no longer return manpower when disbanded
- Enemy air superiority impact reduced (-0.35 to -0.25)
- Anti-air targeting improved

## Germany
- Brand new Army focus tree
- **Summer offensives**: decisions for Typhoon (1941), Fall Blau (1942), and Zitadelle (1943) — available May-August each year, grant **temporary combat bonuses for 90 days**
- **Endsieg**: if active and Germany is winning, grants **+40% defense, +30% attack, +10% org, +10 max dig-in**
- **Deutsche Arbeitsfront**: +5% industrial capacity, -5% stability
- **Totalen Krieg**: +20% war support, +50% political power, +10% surrender limit
- **Volkssturm**: cheap infantry (-25% cost, -20% stats)
- StuG III focus reduces tank destroyer cost by 10%
- Removed several minor nation alliance focuses (Bhutan, Nepal, Afghanistan)

## USA
- USA starts with "Enforced Neutrality" spirit, **preventing it from joining alliances or declaring wars** (but not from answering call to arms from allies or guaranteed nations). The spirit will be removed after June 1st 1941 or if US finds itself at war
- If UK mainland is invaded, **US will immediately join the Allies**
- If Japan is at war with the UK, a year-long timer will start and **US will join the Allies** after it runs out
- **The Philippines are independent** at the start of the game, but are guaranteed by the US. **Philippines will be annexed** should US find itself at war
- Starts with **"Rubber Industry Rivalry"** (-75% synthetic refinery production)
- Democratic threshold relaxed (0.95 to 0.80) for easier access to political branches

## USSR
- USSR is able to **embargo Japan** through a decision, if it is at war with Germany and Japan is at war with UK
- USSR starts with "Enduring Spirit" idea, **providing +100% surrender limit**. If USSR loses control over Leningrad, Moscow and Stalingrad a 90 day timer will start, replacing +100% bonus with a -100% one if it runs out (**this will lead to USSR surrendering**). Should USSR regain control over any of the above-mentioned cities **the timer will be reset**
- USSR production efficiency growth has been **massively** nerfed
- **Winter offensives**: 3 annual decisions (1941-1943, Nov-Jan windows) granting **-15% supply consumption, -30% winter attrition, +30% attack, +10% speed** for 90 days
- **Winter War debuff**: temporary penalties when fighting Finland before 1940
- **Soviet offensive** decision available during Winter War (Oct 1939 - Jan 1940)
- **Leningrad security**: controlling Karelia grants a 2-year defensive bonus; losing it removes the bonus
- **Prepare the Terrain**: pre-war decision to build air bases near Leningrad (costs 2 civilian factories)
- USSR **automatically grants military access to Spain** if it has volunteers there
- **Red Volunteer Army**: -80% volunteer cost (timed idea from multiple focuses)
- New character: Elusivsky Erodditch

## Japan
- Japan got slightly buffed here and there
- Iwo Jima is now in 3 parts
- Once it gains control over Indochina, Japan gets a decision to occupy Siam, **preventing Siam from refusing call to arms**
- Japan has **a truce with the USSR** at game start, which prevents it from declaring war. **The truce will be removed** should India capitulate
- **Indochina demand**: transfers French Indochina states to Japan, triggers USA response window
- **Singapore takeover** decision: if Siam controls Singapore, Japan can take it
- **Balloon bombing** decision: repeating joke decision when at war with USA
- Can send volunteers to Spain
- **Early war bonuses** (before 1940): +20% attack vs China, +10% army attack, industrial penalties offset by arms production
- **Late war bonuses** (until June 1941): industrial capacity and dockyard bonuses, but **cannot join factions or declare war**
- Removed alliance focuses for Bhutan, Nepal, Afghanistan

## France
- **Navy transfer**: France can transfer its entire navy to England when triggered
- **Rise of Resistance**: when France falls, halves compliance in all French core states not under French control (+20% resistance target, +30% resistance growth)
- **African Exiles**: if controlling Morocco and Vichy refused armistice, Free French forces spawn in Casablanca (14 divisions: 11 infantry + 3 alpine)

## China
- **United Front**: when at war with Japan, **annexes all Chinese warlord states** (Sichuan, Yunnan, Guangdong, Guangxi, Shandong, Hebei, Xibei San Ma, Xinjiang, etc.) with troop transfers
- Starts with 1.5 million Type 88 infantry equipment stockpile
- PRC automatically joins China's faction when China is at war with Japan

## Mongolia
- **Brand new focus tree** (100+ focuses) with branching paths
- **The Soviet Control Question**: central mechanic — choose between **Align with Stalin** (communist loyalty) or **Subvert Control** (independence path)
- **Monastic branch**: religious freedom (cooperate with monks, tax breaks) or state atheism (suppress monks, conscript them)
- **Industrial development**: three-stage progression from nomadic economy to industrialized nation — removes starting penalties (nomadic population -50% conscription, wood-framed construction -30% build speed, resource extraction -50% resources)
- **Food for Metal** dynamic modifier system: trade food resources for consumer goods reduction
- **Territorial expansion**: annex Tana Tuva and Sikkang, **Greater Mongolian State** (adds cores to 6+ states), railway integration
- **Military doctrine split**: **Mongolization** (cavalry focus, unlocks Genghis Khan field marshal) vs **Soviet Generals** (armor focus, unlocks Soviet advisors like Konev)
- **Doctrine selection**: traditional warfare (cavalry bonuses) vs modern Mongolian vs full Soviet doctrine
- **War economy**: "WTF Germans" emergency branch when at war with Germany, grants factories and production bonuses
- **Party purge decisions**: kill the commies (independence path) or kill the traditionalists (Stalin path) to shift ideology
- **Resource decisions**: develop coal mines and steel mills in exchange for manpower and civilian factories
- **35+ characters** including historical Mongolian leaders, Soviet advisors, and community-named contributors
- **Genghis Khan MIO**: light tank military industrial organization with 11-trait tech tree
- Starts with heavy penalties (nomadic economy, Soviet control) that get progressively removed through focuses
- Graphical culture changed from Asian to European, new country color

## Siam
- **Brand new focus tree** with political, military, territorial, and industrial branches
- **Political path**: End the Unequal Treaties (removes Bowring Treaty penalty) -> Party Control (introduces Phibunsongkhram as fascist leader) -> Military Rule -> purge royalists -> **Ratthaniyom** (renames country to Thailand)
- **Fate of the Monarchy**: event choice to keep King Rama VIII or abolish the monarchy
- **Golden Peninsula**: territorial claims on Malaya, Burma, Cambodia, Laos, and Indochina with war goals and diplomatic events
- **Empire of Great Thailand**: cosmetic upgrade when controlling claimed territories
- **Industrial branch**: National Economic Plan with autarky dynamic modifier, rice production vs industrial modernization (mutually exclusive), rubber plantations, tungsten production, urbanization
- **Three military branches**:
  - **Army (Thor Bor)**: New Tactics vs Legacy of SEF (mutually exclusive officer training), Bofors mountain gun, ZH-29 rifles, APC investments, marines, Nor Yor special forces, Guards Division
  - **Air Force (Thor Or)**: Local Designs vs Foreign Designs (mutually exclusive), B-KH12 fighter, Martin 139 bomber
  - **Navy (Thor Raw)**: Contest French Dominance (coastal defense) vs Intercept Trade (submarines), torpedo cruisers, destroyers
- **4 research slots** obtainable through focuses (College of Agriculture, Kasetsart University, Chulachomklao Academy)
- Starts with 3 penalty ideas: Bowring Treaty (consumer goods/PP penalty), Royal Opposition, Factionalism
- **Songsuradet Rebellion** mechanic affecting army organization
- Added to **The Gathering Storm bookmark** as a playable minor

## India
- Added **new wartime focuses**: Mobilise the Nation, Mobilise Economy, Recruitment Campaign (+900 weekly manpower)
- **Fortifications**: mutually exclusive choice between fortifying Burma or Bengal
- **Chindits** special forces idea (+3% special forces cap)
- **Bangalore Torpedo** (+10% max dig-in)
- **Hindu Finest Hour**: +20% core defense, +20% dig-in speed
- Changed effects of some existing focuses

## Australia
- **Royal Australian Navy**: -15% light/cruiser ship cost
- **Defense of Mainland**: +30% conscription, +15% dig-in
- **Royal Australian Marines**: +15% special forces cap, -25% marine cost
- **Rats of Tobruk**: -20% supply consumption, -10% heat attrition, +5 max dig-in
- **ANZAC**: +10% attack, +10% breakthrough
- Focus costs reduced across the board (10 to 5 on many focuses)
- Air experience doubled on several focuses

## South Africa
- **Union Defense Force**: +1000 weekly manpower
- **Adaptable Tank Force**: terrain penalty reduction, reduced attrition and fuel consumption
- **War in Desert**: -10% supply consumption, -15% heat attrition, +15% max dig-in
- **South African Paratroopers**: +2% special forces cap
- Combat bonuses vs Germany, Italy, and Japan (+10% attack each)
- **Olifant Tank Production**: -10% heavy tank cost
- **Invite Rhodesia** decision: costs 100 PP, adds SAF core to Zimbabwe at 70% compliance
- Focus costs reduced on many focuses

## United Kingdom
- UK starts with **first marine tech** researched
- After Germany annexes Czechoslovakia, UK will get an event to **guarantee Poland** for 50 political power
- After April 1st 1941 or if Germany has divisions in Matrouh, Iraqi fascist support will be increased, **allowing UK to take "Secure Iraq" focus**
- **Special forces overhaul**: new Commandos focus tree branch (SAS requires Commandos as prerequisite), Parachute Regiment restructured
- **Extensive operations decisions** (each costs 50 command power, 180-day cooldown, 45-day combat bonuses):
  - Mediterranean: Torch, Dragoon, Husky, Compass, Animals
  - Asia: Zipper, Dracula, Oboe, Capital, Cobalt Caesar
  - Europe: Overlord (requires 1944+), Market Garden, Plunder, Jupiter, Sledgehammer
  - Commonwealth: Assemble Commonwealth Corps
- **National spirits**: Royal Engineers, Garrison Empire, Victory at All Cost, Casualty Avoidance, Rationing, Home Front, Women's Land Army, Trade Unions
- **Bomber Command**: +10% strategic bomber bombing
- **Night Fighting**: reduced air night penalties
- **License Tech**: -50% license purchase cost
- **Technological Supremacy**: +3% research speed
- **Habakkuk**: +75% ice carrier production (special project)

## Italy
- Italy starts with **first marine tech** researched

# Known Issues
- USA gets an event each time a country gives them military access, **but the event doesn't work for Paradox Reasons**
- SAF tree is unfinished
