# Architecture Processeurs Pipeline

Implémentation et simulation d'un processeur RISC-V RV32I en HDL pour l'apprentissage de l'architecture des processeurs. Conception du datapath, du control path, exécution d'instructions assembleur et validation par simulation.

## Structure du projet
```
archiproc2/
├── TD1/
│   ├── exo1/
│   │   ├── firmware/
│   │   ├── hdl_src/
│   │   ├── sim/
│   │   └── tb/
│   └── TD1.pdf
├── TD2/
│   ├── exo2/
│   │   ├── firmware/
│   │   ├── hdl_src/
│   │   ├── sim/
│   │   └── tb/
│   └── TD2.pdf
└── TD3/
    ├── exo3/
    │   ├── firmware/
    │   ├── hdl_src/
    │   ├── sim/
    │   └── tb/
    └── TD3.pdf
```

## Caractéristiques

- Architecture RISC-V RV32I
- Séparation datapath/control path
- Exécution d'instructions assembleur
- Gestion registres, ALU et mémoire
- Bancs de test SystemVerilog
- Projets ModelSim/Questa (.mpf, dossier work/)

## Prérequis

- ModelSim ou Questa
- Chaîne de compilation RISC-V (`riscv32-unknown-elf-gcc`, `objcopy`, `objdump`)
- Linux ou WSL

## Utilisation

### Compilation du firmware
```bash
cd TD1/exo1/firmware
./build.sh
```

### Lancement de la simulation
```bash
cd TD1/exo1/sim
./build.sh
```

Le banc de test principal `RV32i_tb.sv` charge les fichiers mémoire (`imem.hex`, `dmem.hex`) générés depuis le firmware.

## Objectifs pédagogiques

- Comprendre le fonctionnement interne d'un processeur RISC-V
- Corriger les dépendances de données et de contrôle dans un pipeline

## Limitations

- Simulation fonctionnelle uniquement (pas de synthèse FPGA)
- Dépendant des outils de simulation utilisés

## Licence

Projet académique – utilisation libre à des fins pédagogiques.
