class Schema < GraphQL::Schema
  query Types::Query
  mutation Mutations::MutationType
end
