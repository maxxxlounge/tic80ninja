-- title:  Ninja!
-- author: Massimo Fornasier
-- desc:   A letal ninja that kills freaky monsters
-- script: lua

    --gamestate:
	-- 0 start
	-- 1 game
	-- 2 endgame
    Game = {
        state = 0,
        -- at game start, generate enemy every 5 seconds
        enemyGenerationRate=60*5,
        timer=0
    }

    Player={
        x=96,
        width=16,
        y=64,
        vx=0,
        vy=0,
        life=100,
        attack=0,
        onGround=true,
        onTop=true,
        direction=0,
        timer=0,
        moving=false,
        offset=0,
        SpriteIndex=0,
        score=0
    }

    EnemyList={}
    EnemyListLength=0    

    --[[
    
    
    -- manage enemy array (bitmask x,y,)
    function Enemy()
            for i=0,i<EnemyListLength,1 do
                    if math.abs(EnemyList[i].x,Player.x) then
                        EnemyList[i].attack=true
                    end
            end
    end
    
    -- player state:
    -- 0: idle,move
    -- 1: attack
    pstate=0
  ]]--  

    function ManagePlayerAttack()
        Player.offset=0
        if Player.attack >= 30 then
            Player.attack=-15
        end
        if Player.attack<0 then
            Player.attack=Player.attack+1
        end
        if btn(4) and Player.attack==0 then
            Player.attack=1
            Player.timer=0
        end
        if Player.attack>0 then
            Player.attack=Player.attack+1
            Player.offset=64
        end
    end

    function ManagePlayerMove()
        if Player.life<=0 then
            Game.state=2
        end
        Player.moving = false
        Player.vx = 0
        if btn(2) and Player.offset==0 then 
                Player.vx=-1
                Player.direction=1
                Player.moving=true
        end
        if btn(3) and Player.offset==0 then 
                Player.vx=1
                Player.direction=0
                Player.moving=true
        end
        Player.x=Player.x+Player.vx
        Player.y=Player.y+Player.vy
        return
    end
    --[[
    function SetBg()
        stc=0
        for i=0,(240*94)/2-1 do
             v=math.random(255)
                if v>250 then
                    stars[stc]=i
                    stc=stc+1
                end
        end
        starsCount=stc
    end
        --]]

    function GenerateNewEnemy()
        --trace("generate new enemy")
        local e = {
            x=-10,
            y=75,
            vx=0,
            vy=0,
            life=1,
            attack=0,
            direction=0,
            onGround=true,
            onTop=false,
            died=false,
            timer=0,
            offset=0,
            SpriteIndex=0
        }
        local rnd = math.random(10)
        if rnd%2==0 then
            e.x=250
            e.direction=0
        end
        table.insert(EnemyList,e)
        EnemyListLength=EnemyListLength+1
    end

    function ManageEnemy()
        for ei=0,EnemyListLength,1 do
            if EnemyList[ei] ~= nil then
                if EnemyList[ei].died and EnemyList[ei].timer%120==0 then
                    table.remove(EnemyList,ei)
                    break
                end
            end
        end
        if Game.timer % Game.enemyGenerationRate == 0 then
            GenerateNewEnemy()
        end
    end

    function ManageEnemyMove()
        for ei=0,EnemyListLength,1 do
            if EnemyList[ei] ~= nil then
                if EnemyList[ei].died then
                    EnemyList[ei].offset=10
                    break
                end
                local e = EnemyList[ei]
                if e.timer%4==0 then
                    if e.x<Player.x and e.attack==0 then    
                        trace("fwd")
                        e.direction=1
                    end                
                    if e.x>=(Player.x) and e.attack==0 then
                        trace("back")
                        e.direction=0
                    end
                    e.vy = 0
                    if e.y <= 75  then
                        e.vy = 4
                    end
                    if e.attack>0 then
                        e.vy = -4
                    end
                    if e.attack > 0 then
                        e.vx = 4
                    end
                    if e.attack==0 then
                        e.vx=1
                    end
                    --trace(string.format("%s",e.vx))
                    e.y = e.y + e.vy
                    if e.direction==0 then
                        e.x = e.x - e.vx
                    else
                        e.x = e.x + e.vx
                    end
                end
            end
        end
    end

    function ManageEnemyAttack()
        for ei=0,EnemyListLength,1 do
            if EnemyList[ei] ~= nil then
                local e = EnemyList[ei]
                if e.died==false then
                    e.offset=0
                end
                if e.attack>=30 then
                    e.attack=-30
                end
                if e.attack<0 then
                    e.attack=e.attack+1
                end
                trace(string.format("e:%s p:%s e.x-Player.x:%s atk:%s",e.x,Player.x,e.x-Player.x,e.attack))
                if (math.abs(Player.x-e.x)<Player.width) and e.attack==0 then
                    e.attack=1
                    e.timer=0
                    if Player.attack>e.attack then
                        e.life = e.life-1
                        Player.score = Player.score+1
                    else
                        Player.life = Player.life-1
                    end
                    if e.life<=0 then
                        e.died=true
                        e.timer=0
                        e.attack=0
                    end
                end
                if e.attack > 0 then
                    e.attack = e.attack+1
                    e.offset = 4
                end
            end
        end
    end

    function SetEnemySpriteIndex()
        for ei=0,EnemyListLength,1 do
            if EnemyList[ei] ~= nil then
                local e = EnemyList[ei]
                if EnemyList[ei].died==false then
                    e.SpriteIndex= 384+e.offset+e.timer%30//10*2
                else
                    e.SpriteIndex= 384+8+e.timer%30//10*2
                end
            end
        end
    end

    function SetPlayerSpriteIndex()
        Player.SpriteIndex = 256+Player.offset+Player.timer%30//8*4
    end

    function DrawElements()
        spr(Player.SpriteIndex,Player.x,Player.y,14,1,Player.direction,0,4,4)
        for ei=0,EnemyListLength,1 do
            if EnemyList[ei] ~= nil then
                spr(EnemyList[ei].SpriteIndex,EnemyList[ei].x,EnemyList[ei].y,14,1,EnemyList[ei].direction,0,2,2)
            end
        end
    end
    
    function DrawText()
        print((string.format("Life: %s",Player.life)),2,2,15)
        print((string.format("Score: %s",Player.score)),100,2,15)
    end

    function IncTimers()
        Player.timer = Player.timer+1
        for ei=0,EnemyListLength,1 do
            if EnemyList[ei] ~= nil then
                EnemyList[ei].timer = EnemyList[ei].timer+1
            end
        end
        Game.timer = Game.timer+1
    end

    function GameLoop()
        ManagePlayerMove()
        ManagePlayerAttack()
        SetPlayerSpriteIndex()
        
        ManageEnemy()
        ManageEnemyMove()
        ManageEnemyAttack()
        SetEnemySpriteIndex()
        
        cls(0)
        map()
        DrawElements()
        
        DrawText()
        IncTimers()
    end


    function Start(t)
        if loop==false then
                --SetBg()
                loop=true	
        end
        if Player.timer%5==0 then
            cls(0)
            print("NINJA",70,30,14,true,3)
            print("press X to start",72,60,15)
            if btn(5) then
                    Game.state=1
            end
        end
    end

    function End()
        cls(0)
        print("GAME OVER",45,30,14,true,3)
        print(string.format("score: %s",Player.score),70,60,15)
        print("press X to quit",60,70,15)
        if btn(5) then
            exit()
        end
    end

    function TIC()
        if Game.state==0  then
            Start(Player.timer)
            Player.timer=Player.timer+1
            return
        end
        
        if Game.state==1 then
            GameLoop()
            return
        end
        
        if Game.state==2 then
            End()
            return
        end
    end
    
  