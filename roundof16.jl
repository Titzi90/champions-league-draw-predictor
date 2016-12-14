#! /bin/julia

#=
This script calculates the properties of the drawing for the
round of sixteen of the UEFA Champions League.

The algorithem based on the rules of the season 2016/17.


This script is licensed under the MIT "Expat" License:

> Copyright (c) 2016: Christopher Bross.
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
> CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
> TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
> SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=#


using Combinatorics

type Club
    name
    association
    group
end

#=
Results from the UEFA Champions League group stage 2016/17

Group A                     Group B
------------------------    ------------------------
1. FC Arsenal               1. SSC Neaple
2. Paris St. Germain        2. Benfica Lisbon

Group C                     Group D
------------------------    ------------------------
1. FC Barcelona             1. Atlético Madrid
2. Manchester City          2. FC Bayern München

Group E                     Group F
------------------------    ------------------------
1. AS Monaco                1. Borussia Dortmund
2. Bayer 04 Leverkusen      2. Real Madrid

Group G                     Group H
------------------------    ------------------------
1. Leicester City           1. Juventus Turin
2. FC Porto                 2. FC Sevilla
=#

# Group winner:
arsenal = Club("Arsenal London", "ENG", "A")
napoli = Club("Napoli", "ITA", "B")
barca  = Club("FC Barcelona", "ESP", "C")
atletico = Club("Atlético Madrid", "ESP", "D")
monaco = Club("AS Monaco", "FRA", "E")
dortmund = Club("Borussia Dortmund", "GER", "F")
leicester = Club("Leicester City", "ENG", "G")
juve = Club("Juventus Turin", "ITA", "H")

# Group second
paris = Club("Paris Saint-Germain", "FRA", "A")
benfica = Club("Benfica Lisabon", "POR", "B")
mancity = Club("Manchester City", "ENG", "C")
bayern = Club("FC Bayern", "GER", "D")
leverkusen = Club("Baya Leverkusen", "GER", "E")
real   = Club("Real Madrid", "ESP", "F")
porto = Club("FC Porto", "POR", "G")
sevilla = Club("Sevilla", "ESP", "H")


winner = [arsenal, napoli, barca, atletico, monaco, dortmund, leicester, juve]
second = [paris, benfica, mancity, bayern, leverkusen, real, porto, sevilla]



function calculatePropertiesOfRoundOf16(winner::Array{Club,1}, second::Array{Club,1})
    @assert size(winner) == size(second)

    second_perm = permutations(second)
    blancDict = Dict("blanc" => -1)
    oponents = Dict("blanc" => blancDict) #TODO how to do it with emty dict???
    numberOfLeagalDraws = 0

    for iter in second_perm
        matches = permutedims([winner iter], [2, 1])

        # check for leagel draws
        leagel = true
        for m in 1:length(winner)
            team1 = matches[1,m]
            team2 = matches[2,m]

            leagel = team1.association != team2.association &&
                     team1.group       != team2.group       &&
                     leagel
        end

        # count leagel draws
        if leagel
            numberOfLeagalDraws += 1

            for m in 1:length(winner)
                team1 = matches[1,m].name
                team2 = matches[2,m].name

                # add for team 1
                oponents[team1] = get(oponents, team1, Dict(team2 => 0))
                oponents[team1][team2] = get(oponents[team1], team2, 0) + 1

                # add for team 2
                oponents[team2] = get(oponents, team2, Dict(team1 => 0))
                oponents[team2][team1] = get(oponents[team2], team1, 0) + 1
            end
        end
    end

    delete!(oponents, "blanc")

    # calculate properties and print them
    println("Possible opponents for the terms are:")
    for o in oponents
        println("$(o[1])")
        for oo in o[2]
            println("\t$(oo[1]): $(oo[2]/numberOfLeagalDraws * 100)%")
        end
    end
end

# call function
calculatePropertiesOfRoundOf16(winner, second)
