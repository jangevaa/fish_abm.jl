"""
Functions and types for agent-level model components
Justin Angevaare
April 2015
"""

# type agent_db
#   """
#   A very basic type specified for conveinence; methods can be created for the type
#   """
#   DataFrame
# end

type agent_assumptions
  """
  Assumptions regarding mortality, movement, and growth
  """
  mortality_natural::Array
  mortality_risk::Vector
  growth::Vector
#   movement
end

function create_agent_db(cohorts)
  """
  A function which will create an empty agent_db for the specified simulation length
  """
  sub_agent_db = DataFrame(cohort = DataFrame(stage=Int[], location=Int[], alive=Int[], dead_natural=Int[], dead_risk=Int[]))
  int_agent_db = hcat(sub_agent_db, sub_agent_db)
  for i = 1:102
    int_agent_db=hcat(int_agent_db, sub_agent_db)
  end
  names!(int_agent_db, [symbol("week_$i") for i in 1:104])
  agent_db = vcat(int_agent_db, int_agent_db)
  for i = 1:(cohorts-2)
    agent_db = vcat(agent_db, int_agent_db)
  end
  return agent_db
#   return int_agent_db
end

function kill!(agent_db::DataFrame, environment_assumptions::environment_assumptions, agent_assumptions::agent_assumptions, cohort::Int, week::Int)
  """
  This function will kill agents based on all stage and location specific risk factors described in a `environment_assumptions`
  """
  agent_db[cohort, week][:stage]
  agent_db[cohort, week][:alive]
  for i = 1:length(agent_db[cohort, week][:alive])
    killed = minimum([rand(Poisson(agent_db[cohort, week][:alive][i]*agent_assumptions.mortality_natural[environment_assumptions.habitat[agent_db[cohort, week][:location][i].==environment_assumptions.id],agent_db[cohort, week][:stage][i]][1])), agent_db[cohort, week][:alive][i]])
    agent_db[cohort, week][:dead_natural][i] += killed
    agent_db[cohort, week][:alive][i] -= killed
    if environment_assumptions.risk[agent_db[cohort, week][:location][i].==environment_assumptions.id][1]
      killed = minimum([rand(Poisson(agent_db[cohort, week][:alive][i]*agent_assumptions.mortality_risk[agent_db[cohort, week][:stage][i]][1])), agent_db[cohort, week][:alive][i]])
      agent_db[cohort, week][:dead_risk][i] += killed
      agent_db[cohort, week][:alive][i] -= killed
    end
  end
end

function move!(agent_db::DataFrame, environment_assumptions::environment_assumptions)
  """
  This function will move agents based on current for larvae, current and carrying capacity for juveniles
  """
end

function inject_juveniles!(agent_db::DataFrame, location::Int, size::Int)
  """
  This function will inject juveniles into an `agent_db` to simulate stocking efforts.
  """
end
