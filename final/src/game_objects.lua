--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['pot'] = {
        type = 'pot',
        texture = 'tiles',
        frame = 14,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'intact',
        states = {
            ['intact'] = {
                frame = 14
            },
            ['broken'] = {
                frame = 52
            }
        }
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        item = true,
        defaultState = 'default',
        states = {
            ['default'] = {
                frame = 5
            }
        }
    },
    ['potion'] = {
        type = 'potion',
        texture = 'potion',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = '1',
        item = true,
        states = {
            ['1'] = {
                frame = 1
            },
            ['2'] = {
                frame = 2
            }
        }
    },
    ['chest'] = {
        type = 'chest',
        texture = 'chest',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = 'closed',
        states = {
            ['closed'] = {
                frame = 1
            },
            ['opened'] = {
                frame = 2
            }
        }
    },
    ['key'] = {
        type = 'key',
        texture = 'key',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = '1',
        item = true,
        states = {
            ['1'] = {
                frame = 1
            },
            ['2'] = {
                frame = 2
            }
        }
    },
    ['sword-normal'] = {
        type = 'normal',
        texture = 'sword-normal',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = '1',
        item = true,
        states = {
            ['1'] = {
                frame = 1
            },
            ['2'] = {
                frame = 2
            }
        }
    },
    ['sword-fire'] = {
        type = 'fire',
        texture = 'sword-fire',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = '1',
        item = true,
        states = {
            ['1'] = {
                frame = 1
            },
            ['2'] = {
                frame = 2
            }
        }
    },
    ['sword-poison'] = {
        type = 'poison',
        texture = 'sword-poison',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = '1',
        item = true,
        states = {
            ['1'] = {
                frame = 1
            },
            ['2'] = {
                frame = 2
            }
        }
    },
    ['crossbow-ice'] = {
        type = 'ice',
        texture = 'crossbow-ice',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = '1',
        item = true,
        states = {
            ['1'] = {
                frame = 1
            },
            ['2'] = {
                frame = 2
            }
        }
    },
    ['crossbow-acid'] = {
        type = 'acid',
        texture = 'crossbow-acid',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = '1',
        item = true,
        states = {
            ['1'] = {
                frame = 1
            },
            ['2'] = {
                frame = 2
            }
        }
    },
    ['arrow-ice'] = {
        type = 'ice',
        texture = 'arrow-ice',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = 'down',
        states = {
            ['down'] = {
                frame = 1
            },
            ['up'] = {
                frame = 2
            },
            ['right'] = {
                frame = 3
            },
            ['left'] = {
                frame = 4
            },
            ['explosion'] = {
                frame = 5
            }
        }
    },
    ['arrow-acid'] = {
        type = 'ice',
        texture = 'arrow-acid',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = 'down',
        states = {
            ['down'] = {
                frame = 1
            },
            ['up'] = {
                frame = 2
            },
            ['right'] = {
                frame = 3
            },
            ['left'] = {
                frame = 4
            },
            ['explosion'] = {
                frame = 5
            }
        }
    },
    ['spider-shot'] = {
        type = 'projectile',
        texture = 'spider-shot',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = 'down',
        states = {
            ['down'] = {
                frame = 1
            },
            ['up'] = {
                frame = 2
            },
            ['right'] = {
                frame = 3
            },
            ['left'] = {
                frame = 4
            },
            ['explosion'] = {
                frame = 5
            }
        }
    },
    ['slime-shot'] = {
        type = 'projectile',
        texture = 'slime-shot',
        frame = 1,
        width = 16,
        height = 18,
        solid = false,
        defaultState = 'down',
        states = {
            ['down'] = {
                frame = 1
            },
            ['up'] = {
                frame = 2
            },
            ['right'] = {
                frame = 3
            },
            ['left'] = {
                frame = 4
            },
            ['explosion'] = {
                frame = 5
            }
        }
    }
}