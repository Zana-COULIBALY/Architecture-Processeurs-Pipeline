# Architecture-Processeurs-Pipeline


Implémentation et simulation d’un processeur RISC-V RV32I en HDL dans le cadre de travaux pratiques d’architecture des processeurs.
Le projet couvre la conception du datapath, du control path, l’exécution d’instructions assembleur et la validation par simulation.

📁 Structure du dépôt
archiproc2/
├── TD1/
│   └── exo1/
│       └── firmware/
|       └── hdl_src/
|       └── sim
|       └── tb
|   TD1.pdf
├── TD2/
│   └── exo2/
│       └── firmware/
|       └── hdl_src/
|       └── sim
|       └── tb
│   TD2.pdf
|
└── TD3/
|    ├── exo3/
│       └── firmware/
|       └── hdl_src/
|       └── sim
|       └── tb
|   TD3.pdf

🚀 Fonctionnalités

Architecture RISC-V RV32I

Datapath et control path séparés

Exécution d’instructions assembleur

Gestion des registres, ALU et mémoire

Simulation complète via bancs de test SystemVerilog

Projets prêts à l’emploi sous ModelSim / Questa

🧪 Simulation

Banc de test principal : RV32i_tb.sv

Projets ModelSim fournis (.mpf, dossier work/)

Chargement des fichiers mémoire (imem.hex, dmem.hex) générés depuis le firmware

🔧 Prérequis

ModelSim ou Questa

Chaîne de compilation RISC-V
(riscv32-unknown-elf-gcc, objcopy, objdump)

Linux ou WSL recommandé

▶️ Utilisation rapide

Compiler le firmware :

cd TD1/exo1/firmware
./build.sh


Lancer la simulation via ModelSim : 
cd TD1/exo1/sim
./build.sh


Observer l’exécution des instructions et les signaux internes

🎯 Objectifs du projet

Comprendre le fonctionnement interne d’un processeur RISC-V

Apprendre à corriger les dépendances de données et de contrôle dans un pipeline.

⚠️ Limitations

Projet non destiné à la synthèse FPGA

Simulation fonctionnelle uniquement

Dépendance aux outils de simulation utilisés

📜 Licence

Projet académique – utilisation libre à des fins pédagogiques.
