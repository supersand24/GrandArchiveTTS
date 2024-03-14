local playerColor = "Yellow"
local playmatGUID = "b90a1d"

function onGenerateCardButtonPressed()

    local url = self.Browser.url

    if Global.call("stringStartsWith",{string=url,startsWith="https://index.gatcg.com/"}) then
        
        --Get Tokens Zone
        local playmat = getObjectFromGUID(playmatGUID)
        local tokensZone = playmat.call("getTokensZone")

        --Card Edition in URL on Tablet
        if Global.call("stringStartsWith",{string=url,startsWith="https://index.gatcg.com/edition/"}) then

            --Get Slug
            local slug = Global.call("removeStringFromStart", {string=url,remove="https://index.gatcg.com/edition/"})

            --Get Card Data
            local url = "https://api.gatcg.com/cards/edition/" .. slug
            WebRequest.get(url, function(request)
                if request.is_error then
                    log(request.error)
                elseif request.response_code == 204 then
                    log("No card was found. Slug:" .. slug)
                elseif request.response_code == 200 then
                    --Request was successful.

                    --Format Card Data
                    local cardEdition = JSON.decode(request.text)

                    --Get Image
                    local imageURL = "https://ga-index-public.s3.us-west-2.amazonaws.com/cards/" .. slug .. ".jpg"

                    --Spawn Card
                    Global.call("spawnGrandArchiveCard", {
                        name = cardEdition.name,
                        image = imageURL,
                        pos = tokensZone.getPosition(),
                        rot = {y = (playmat.getRotation().y - 90)}
                    })

                else
                    log("Unknown issue getting Card Data.")
                end
            end)

        --Card was searched
        elseif Global.call("stringStartsWith",{string=url,startsWith="https://index.gatcg.com/card/"}) then

            --Get Slug
            local slug = Global.call("removeStringFromStart", {string=url,remove="https://index.gatcg.com/card/"})

            --Get Card Data
            local url = "https://api.gatcg.com/cards/" .. slug
            WebRequest.get(url, function(request)
                if request.is_error then
                    log(request.error)
                elseif request.response_code == 204 then
                    log("No card was found. Slug:" .. slug)
                elseif request.response_code == 200 then
                    --Request was successful.

                    --Format Card Data
                    local cardData = JSON.decode(request.text)

                    --Get Slug (Edition)
                    slug = cardData.editions[1].slug

                    --Get Image
                    local imageURL = "https://ga-index-public.s3.us-west-2.amazonaws.com/cards/" .. slug .. ".jpg"

                    --Spawn Card
                    Global.call("spawnGrandArchiveCard", {
                        name = cardData.name,
                        image = imageURL,
                        pos = tokensZone.getPosition(),
                        rot = {y = 90}
                    })

                else
                    log("Unknown issue getting Card Data.")
                end
            end)

        end
    else
        log("I can only generate cards from the Official Grand Archive Database.")
        self.Browser.url = "https://index.gatcg.com/cards"
    end

end

function getCardEditionInfo(slug)

    local url = "https://api.gatcg.com/cards/" .. slug
  
    WebRequest.get(url, function(request)
      if request.is_error then
        log(request.error)
      elseif request.response_code == 204 then
        log("No card was found. Slug:" .. slug)
      elseif request.response_code == 200 then
        local json = JSON.decode(request.text)
        log(json)
        return json
      else
        log("Unknown issue getting Card Data.")
      end
    end)
  
  end