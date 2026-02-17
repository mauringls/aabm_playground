# Dependencies

using Agents                # Agents

using Graphs                # Graphs
using SimpleWeightedGraphs

using GLMakie               # Plotting
using GraphMakie

using Random                # Randomness
using Distributions

#-------------------------------#
#--          AGENTS           --#
#-------------------------------#

# Augmented model
@agent struct ContinuousDebatorAgent(GraphAgent)
    σ::Float64 # between -1 and 1
end

#-------------------------------#
#--           SPACE           --#
#-------------------------------#

gr = smallgraph(:karate)

#-------------------------------#
#--           MODEL           --#
#-------------------------------#

function AugIsingModel()
    #TODO
end


#-------------------------------#
#--         EVOLUTION         --#
#-------------------------------#

function agent_step!(agent, model)
    #TODO
end

#-------------------------------#
#--        IMPROVEMENT        --#
#-------------------------------#

function ϕ_interaction(i,j;
    κ=1.5, # threshold before respulsion
    α=0.2  # strength of the learning
)
    return α * tanh(κ-abs(b-a)) * (b*abs(b-a))
end

# J is a weighted directed copy of our graph space
# It defines the influence of an agent j to an agent i
# This gives the J_{i,j} in the formula
function createJ(gr::Graph;α=2,θ=0.5)
    γ_distrib = Gamma(α,θ)

    grd = SimpleWeightedDiGraph(nv(gr))

    for e in edges(gr)
        u = src(e)
        v = dst(e)

        uv_w = 0.1*maximum(rand(γ_distrib,degree(gr,v)))
        vu_w = 0.1*maximum(rand(γ_distrib,degree(gr,u)))

        add_edge!(grd,u,v,uv_w)
        add_edge!(grd,v,u,vu_w)
    end

    return grd
end


#-------------------------------#
#--          RUNNING          --#
#-------------------------------#

model = AugIsingModel(gr)