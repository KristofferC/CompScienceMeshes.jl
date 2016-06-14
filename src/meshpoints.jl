export meshpoint
export meshpoints
export paramtype, pointtype
export cartesian, parametric, barycentric
export jacobian, tangents, utangents, normal

export MeshPointNM

immutable MeshPointNM{U,D,C,N,T}
    patch::FlatCellNM{U,D,C,N,T}
    bary::Vec{D,T}
    cart::Vec{U,T}
end


paramtype{U,D,C,N,T}(::MeshPointNM{U,D,C,N,T}) = Vec{D,T}
pointtype{U,D,C,N,T}(::MeshPointNM{U,D,C,N,T}) = Vec{U,T}

cartesian(mp::MeshPointNM) = mp.cart
parametric(mp::MeshPointNM) = mp.bary
barycentric(mp::MeshPointNM) = Vec(mp.bary[1], mp.bary[2], 1-mp.bary[1]-mp.bary[2])

jacobian(mp::MeshPointNM) = volume(mp.patch) * factorial(dimension(mp.patch))
tangents(mp::MeshPointNM, i) = mp.patch.tangents[i]
function utangents(mp::MeshPointNM, i)
    tang = mp.patch.tangents[i]
    return tang / norm(tang)
end
normal(mp::MeshPointNM) = mp.patch.normals[1]

function meshpoint(p::FlatCellNM, bary)
  D = dimension(p)
  T = coordtype(p)
  P = Vec{D,T}
  cart = barytocart(p, bary)
  MeshPointNM(p, P(bary), cart)
end


function meshpoints{U,D,C,N,T}(p::FlatCellNM{U,D,C,N,T}, uv::Array{T,2})
    numpoints = size(uv, 2)
    mps = Array(MeshPointNM{U,D,C,N,T}, numpoints)
    for i in 1:numpoints
        mps[i] = meshpoint(p, uv[:,i])
    end
    return mps
end
