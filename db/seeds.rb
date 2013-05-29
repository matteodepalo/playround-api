dota2 = Game.build_and_create(name: :dota2)
go = Game.build_and_create(name: :go)
table_football = Game.build_and_create(name: :table_football)

test_user = User.create(name: 'test')
participant = User.create(name: 'participant')
round = Round.create(user: test_user, game: go)
Participation.create(user: participant, round: round)