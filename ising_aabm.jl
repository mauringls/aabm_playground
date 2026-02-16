# Important dependencies

using Agents
using Graphs
using CairoMakie
using GraphMakie
using Random: MersenneTwister

#-------------------------------#
#--          AGENTS           --#
#-------------------------------#

@agent struct DebatorAgent(GraphAgent)
    σ::Int8 # +1/-1
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
#--          RUNNING          --#
#-------------------------------#

model = IsingModel(gr)

# TODO: make automatic plotting possible
# May be possible using graph in model parameters
# rather than a space type
# abmvideo("ising.mp4",model)

# debator_agent_color(id, model) = model[id].σ == 1 ? :red : :blue

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

record(fig, "ising.mp4", 1:100) do i
    step!(model, 1)
end