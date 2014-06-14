ALTER KEYSPACE Excelsior
          WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 4};