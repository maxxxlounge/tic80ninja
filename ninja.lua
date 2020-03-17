-- title:  Ninja!
-- author: Massimo Fornasier
-- desc:   A letal ninja that kills freaky monsters
-- script: lua

    --gamestate:
	-- 0 start
	-- 1 game
	-- 2 endgame
    Gamestate=0

    Player={
        x=96,
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
        offset=0
    }
    
    Enemy={
        x=0,
        y=64,
        vx=0,
        vy=0,
        life=5,
        attack=false,
        onGround=true,
        onTop=false,
        died=false
    }
    
    EnemyList={}
    EnemyListLength=0
    c = 0

    stars = {}
    starsCount=0
    
    --enemies array
    eenn = {}
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
    
    function LoadEnemy()
        if t%4==0 then
            if ex<p.x then
                ex=ex+1
                de=1
            end
            
            if ex>=p.x then
                ex=ex-1
                de=0
            end
            
            if math.abs(ex,p.x)<5 or eattack==0 then
                    eattack=1
            end
            if eattack==1 then
                    ey=ey-1
                    if ey<44 then
                            eattack=0
                    end
            end
        
        end
        spr(eattack+eo+t%30//10*2,ex,p.y+12,14,1,de,0,2,2)
    end
        --]]

    function ManageEnemy()
        trace("manage enemy")
    end

    function GetPlayerSprite()
        return 256+Player.offset+Player.timer%30//8*4
    end

    function Game()
        ManagePlayerMove()
        ManagePlayerAttack()
        trace(string.format("attack: %s", Player.attack))
        ManageEnemy()
        --[[tick=60
        sNum=30
        cls(0)
        d,offset=ManageMove(offset)
     
        LoadEnemy(x)
        if offset==64 then
            tick=30
            sNum=8
        end
        movingoffset=0
        if isMoving then
            movingoffset=8
        end]]

        pSpriteNr = GetPlayerSprite(Player)
        --trace(pSpriteNr)
        cls(0)
        spr(pSpriteNr,Player.x,Player.y,14,1,Player.direction,0,4,4)
        Player.timer = Player.timer+1
    end


    function Start(t)
        if loop==false then
                --SetBg()
                loop=true	
        end
        if Player.timer%5==0 then
            --cls(0)
            print("NINJA",70,30,14,true,3)
            print("press X to start",72,60,15)
            if btn(5) then
                    Gamestate=1
            end
        end
    end

    function End()
        print("GAME OVER",70,30,14,true,3)
        print("press X to quit",72,60,15)
        if btn(5) then
            exit()
        end
    end

    function TIC()
        if Gamestate==0  then
            Start(Player.timer)
            Player.timer=Player.timer+1
            return
        end
        
        if Gamestate==1 then
            Game()
            return
        end
        
        if Gamestate==2 then
            End()
            return
        end
    end
    
  