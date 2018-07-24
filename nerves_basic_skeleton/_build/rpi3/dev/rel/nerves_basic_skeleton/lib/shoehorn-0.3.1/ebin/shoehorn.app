{application,shoehorn,
             [{applications,[kernel,stdlib,elixir,crypto]},
              {description,"Get your boot on.\n"},
              {modules,['Elixir.Shoehorn','Elixir.Shoehorn.Application',
                        'Elixir.Shoehorn.Application.Module',
                        'Elixir.Shoehorn.Application.PrivDir',
                        'Elixir.Shoehorn.Application.PrivDir.File',
                        'Elixir.Shoehorn.ApplicationController',
                        'Elixir.Shoehorn.Handler',
                        'Elixir.Shoehorn.Handler.Ignore',
                        'Elixir.Shoehorn.Handler.Proxy',
                        'Elixir.Shoehorn.Overlay','Elixir.Shoehorn.Plugin',
                        'Elixir.Shoehorn.Utils']},
              {registered,[]},
              {vsn,"0.3.1"},
              {extra_applications,[crypto]},
              {mod,{'Elixir.Shoehorn',[]}}]}.