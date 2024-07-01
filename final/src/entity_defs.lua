--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

ENTITY_DEFS = {
    ['player-male'] = {
        meleeWeapon = 'normal',
        rangedWeapon = '',
        walkSpeed = PLAYER_WALK_SPEED,
        movement = 96,
        range = false,
        ac = 10, 
        animations = {
            ['walk-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.155,
                texture = 'character-male-walk'
            },
            ['walk-right'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'character-male-walk'
            },
            ['walk-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                texture = 'character-male-walk'
            },
            ['walk-up'] = {
                frames = {9, 10, 11, 12},
                interval = 0.15,
                texture = 'character-male-walk'
            },
            ['idle-left'] = {
                frames = {13},
                texture = 'character-male-walk'
            },
            ['idle-right'] = {
                frames = {5},
                texture = 'character-male-walk'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'character-male-walk'
            },
            ['idle-up'] = {
                frames = {9},
                texture = 'character-male-walk'
            },
            ['sword-left-normal'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-normal'
            },
            ['sword-right-normal'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-normal'
            },
            ['sword-down-normal'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-normal'
            },
            ['sword-up-normal'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-normal'
            },
            ['sword-left-fire'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-fire'
            },
            ['sword-right-fire'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-fire'
            },
            ['sword-down-fire'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-fire'
            },
            ['sword-up-fire'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-fire'
            },
            ['sword-left-poison'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-poison'
            },
            ['sword-right-poison'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-poison'
            },
            ['sword-down-poison'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-poison'
            },
            ['sword-up-poison'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-male-swing-sword-poison'
            },
            ['crossbow-left-ice'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-ice'
            },
            ['crossbow-right-ice'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-ice'
            },
            ['crossbow-down-ice'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-ice'
            },
            ['crossbow-up-ice'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-ice'
            },
            ['crossbow-left-acid'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-acid'
            },
            ['crossbow-right-acid'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-acid'
            },
            ['crossbow-down-acid'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-acid'
            },
            ['crossbow-up-acid'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-male-shoot-crossbow-acid'
            },
            ['hold-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.155,
                texture = 'character-male-hold'
            },
            ['hold-right'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'character-male-hold'
            },
            ['hold-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                texture = 'character-male-hold'
            },
            ['hold-up'] = {
                frames = {9, 10, 11, 12},
                interval = 0.15,
                texture = 'character-male-hold'
            },
            ['idle-hold-left'] = {
                frames = {13},
                texture = 'character-male-hold'
            },
            ['idle-hold-right'] = {
                frames = {5},
                texture = 'character-male-hold'
            },
            ['idle-hold-down'] = {
                frames = {1},
                texture = 'character-male-hold'
            },
            ['idle-hold-up'] = {
                frames = {9},
                texture = 'character-male-hold'
            },
            ['lift-left'] = {
                frames = {10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-male-lift'
            },
            ['lift-right'] = {
                frames = {4, 5, 6},
                interval = 0.05,
                looping = false,
                texture = 'character-male-lift'
            },
            ['lift-down'] = {
                frames = {1, 2, 3},
                interval = 0.05,
                looping = false,
                texture = 'character-male-lift'
            },
            ['lift-up'] = {
                frames = {7, 8, 9},
                interval = 0.05,
                looping = false,
                texture = 'character-male-lift'
            }
        }
    },
    ['player-female'] = {
        meleeWeapon = 'normal',
        rangedWeapon = '',
        walkSpeed = PLAYER_WALK_SPEED,
        movement = 96,
        range = false, 
        ac = 10,
        animations = {
            ['walk-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.155,
                texture = 'character-female-walk'
            },
            ['walk-right'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'character-female-walk'
            },
            ['walk-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                texture = 'character-female-walk'
            },
            ['walk-up'] = {
                frames = {9, 10, 11, 12},
                interval = 0.15,
                texture = 'character-female-walk'
            },
            ['idle-left'] = {
                frames = {13},
                texture = 'character-female-walk'
            },
            ['idle-right'] = {
                frames = {5},
                texture = 'character-female-walk'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'character-female-walk'
            },
            ['idle-up'] = {
                frames = {9},
                texture = 'character-female-walk'
            },
            ['sword-left-normal'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-normal'
            },
            ['sword-right-normal'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-normal'
            },
            ['sword-down-normal'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-normal'
            },
            ['sword-up-normal'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-normal'
            },
            ['sword-left-fire'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-fire'
            },
            ['sword-right-fire'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-fire'
            },
            ['sword-down-fire'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-fire'
            },
            ['sword-up-fire'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-fire'
            },
            ['sword-left-poison'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-poison'
            },
            ['sword-right-poison'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-poison'
            },
            ['sword-down-poison'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-poison'
            },
            ['sword-up-poison'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-female-swing-sword-poison'
            },
            ['crossbow-left-ice'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-ice'
            },
            ['crossbow-right-ice'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-ice'
            },
            ['crossbow-down-ice'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-ice'
            },
            ['crossbow-up-ice'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-ice'
            },
            ['crossbow-left-acid'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-acid'
            },
            ['crossbow-right-acid'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-acid'
            },
            ['crossbow-down-acid'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-acid'
            },
            ['crossbow-up-acid'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'character-female-shoot-crossbow-acid'
            },
            ['hold-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.155,
                texture = 'character-female-hold'
            },
            ['hold-right'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'character-female-hold'
            },
            ['hold-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                texture = 'character-female-hold'
            },
            ['hold-up'] = {
                frames = {9, 10, 11, 12},
                interval = 0.15,
                texture = 'character-female-hold'
            },
            ['idle-hold-left'] = {
                frames = {13},
                texture = 'character-female-hold'
            },
            ['idle-hold-right'] = {
                frames = {5},
                texture = 'character-female-hold'
            },
            ['idle-hold-down'] = {
                frames = {1},
                texture = 'character-female-hold'
            },
            ['idle-hold-up'] = {
                frames = {9},
                texture = 'character-female-hold'
            },
            ['lift-left'] = {
                frames = {10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'character-female-lift'
            },
            ['lift-right'] = {
                frames = {4, 5, 6},
                interval = 0.05,
                looping = false,
                texture = 'character-female-lift'
            },
            ['lift-down'] = {
                frames = {1, 2, 3},
                interval = 0.05,
                looping = false,
                texture = 'character-female-lift'
            },
            ['lift-up'] = {
                frames = {7, 8, 9},
                interval = 0.05,
                looping = false,
                texture = 'character-female-lift'
            }
        }
    },
    ['skeleton'] = {
        texture = 'entities',
        movement = 64, 
        range = false, 
        ac = 5,
        animations = {
            ['walk-left'] = {
                frames = {22, 23, 24, 23},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {34, 35, 36, 35},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {10, 11, 12, 11},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {46, 47, 48, 47},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {23}
            },
            ['idle-right'] = {
                frames = {35}
            },
            ['idle-down'] = {
                frames = {11}
            },
            ['idle-up'] = {
                frames = {47}
            },
            ['attack-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'skeleton-attack'
            },
            ['attack-right'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'skeleton-attack'
            },
            ['attack-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'skeleton-attack'
            },
            ['attack-up'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'skeleton-attack'
            }
        }
    },
    ['slime'] = {
        texture = 'entities',
        movement = 48, 
        range = true,
        ac = 5, 
        animations = {
            ['walk-left'] = {
                frames = {61, 62, 63, 62},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {73, 74, 75, 74},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {49, 50, 51, 50},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {86, 86, 87, 86},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {62}
            },
            ['idle-right'] = {
                frames = {74}
            },
            ['idle-down'] = {
                frames = {50}
            },
            ['idle-up'] = {
                frames = {86}
            },
            ['attack-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'slime-attack'
            },
            ['attack-right'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'slime-attack'
            },
            ['attack-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'slime-attack'
            },
            ['attack-up'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'slime-attack'
            }
        }
    },
    ['bat'] = {
        texture = 'entities',
        movement = 80,
        range = false, 
        ac = 5,
        animations = {
            ['walk-left'] = {
                frames = {64, 65, 66, 65},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {76, 77, 78, 77},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {52, 53, 54, 53},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {88, 89, 90, 89},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {64, 65, 66, 65},
                interval = 0.2
            },
            ['idle-right'] = {
                frames = {76, 77, 78, 77},
                interval = 0.2
            },
            ['idle-down'] = {
                frames = {52, 53, 54, 53},
                interval = 0.2
            },
            ['idle-up'] = {
                frames = {88, 89, 90, 89},
                interval = 0.2
            },
            ['attack-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'bat-attack'
            },
            ['attack-right'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'bat-attack'
            },
            ['attack-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'bat-attack'
            },
            ['attack-up'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'bat-attack'
            }
        }
    },
    ['ghost'] = {
        texture = 'entities',
        movement = 64, 
        range = false, 
        ac = 5,
        animations = {
            ['walk-left'] = {
                frames = {67, 68, 69, 68},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {79, 80, 81, 80},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {55, 56, 57, 56},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {91, 92, 93, 92},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {68}
            },
            ['idle-right'] = {
                frames = {80}
            },
            ['idle-down'] = {
                frames = {56}
            },
            ['idle-up'] = {
                frames = {92}
            },
            ['attack-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'ghost-attack'
            },
            ['attack-right'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'ghost-attack'
            },
            ['attack-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'ghost-attack'
            },
            ['attack-up'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'ghost-attack'
            }
        }
    },
    ['spider'] = {
        texture = 'entities',
        movement = 64,
        range = true, 
        ac = 5,
        animations = {
            ['walk-left'] = {
                frames = {70, 71, 72, 71},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {82, 83, 84, 83},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {58, 59, 60, 59},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {94, 95, 96, 95},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {71}
            },
            ['idle-right'] = {
                frames = {83}
            },
            ['idle-down'] = {
                frames = {59}
            },
            ['idle-up'] = {
                frames = {95}
            },
            ['attack-left'] = {
                frames = {13, 14, 15, 16},
                interval = 0.05,
                looping = false,
                texture = 'spider-attack'
            },
            ['attack-right'] = {
                frames = {9, 10, 11, 12},
                interval = 0.05,
                looping = false,
                texture = 'spider-attack'
            },
            ['attack-down'] = {
                frames = {1, 2, 3, 4},
                interval = 0.05,
                looping = false,
                texture = 'spider-attack'
            },
            ['attack-up'] = {
                frames = {5, 6, 7, 8},
                interval = 0.05,
                looping = false,
                texture = 'spider-attack'
            }
        }
    }
}