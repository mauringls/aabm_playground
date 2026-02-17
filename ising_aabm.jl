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

# Classic Ising model
@agent struct DebatorAgent(GraphAgent)
    σ::Int8 # +1/-1
end

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

function IsingModel(
    gr   ;
    # J
    # h
    knn = 2, # useless once we have J
    β = 0.5,
    seed = 67
)

    space = GraphSpace(gr)
    
    properties = Dict(
        :β => β,
        :n_agents => nv(gr)
    )

    model = StandardABM(
        DebatorAgent,
        space;
        properties,
        agent_step!,
        rng = MersenneTwister(seed)
    )

    # add agents to model
    for i in 1:nv(gr)
        add_agent_single!(model, Int8(rand([-1,1])))
    end

    return model
end


#-------------------------------#
#--         EVOLUTION         --#
#-------------------------------#

# TODO: include J and h
# J: interaction strength for each edge (if variates)
# h: magnetic field (external force)

# Let agents evolve
function agent_step!(agent, model)
    neighbours_σ = [model[ag].σ for ag in nearby_ids(agent,model)]
    Hσ = isempty(neighbours_σ) ? 0.0 : sum(neighbours_σ)

    # oversimplified enery computation
    ΔE = 2*agent.σ*Hσ

    # Metropolis
    if (ΔE ≤ 0) || (rand(abmrng(model)) < exp(-model.β*ΔE))
        agent.σ *= -1 # switch spin!
    end
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

model = IsingModel(gr)

# TODO: make automatic plotting possible
# May be possible using graph in model parameters
# rather than a space type
# abmvideo("ising.mp4",model)

function debator_agent_color(agents)
    ags = collect(agents)

    if isempty(ags)
        :gray
    elseif any(a -> a.σ == 1, ags)
        :red
    else
        :blue
    end
end

fig, ax, abmobs = abmplot(
    model;
    agent_color = debator_agent_color,
    graphplot = true
)

record(fig, "ising.mp4", 1:40;framerate=2) do i
    step!(model, 1)
    abmobs.model[] = model
end