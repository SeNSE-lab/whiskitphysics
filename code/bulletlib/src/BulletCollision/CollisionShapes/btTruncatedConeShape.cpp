/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2009 Erwin Coumans  http://bulletphysics.org

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose, 
including commercial applications, and to alter it and redistribute it freely, 
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

#include "btTruncatedConeShape.h"



btTruncatedConeShape::btTruncatedConeShape (btScalar radius1,btScalar radius2, btScalar height, btScalar axis): btConvexInternalShape (),
m_radius1 (radius1),m_radius2 (radius2),
m_height(height), m_axis(axis)
{
	m_shapeType = TRUNCATED_CONE_SHAPE_PROXYTYPE;
	
	setConeUpIndex(m_axis);
	m_halfExtent = height/2.;
	m_com = (m_height)/4*(pow(m_radius1,2) + 2*m_radius1*m_radius2 + 3*pow(m_radius2,2))/(pow(m_radius1,2) + m_radius1*m_radius2 + pow(m_radius2,2));
	m_sinAngle = ((m_radius1-m_radius2) / btSqrt((m_radius1-m_radius2) * (m_radius1-m_radius2) + m_height * m_height));
}


// void btTruncatedConeShape::getAabb(const btTransform& t,btVector3& aabbMin,btVector3& aabbMax) const
// {
// 	btVector3 localAabbMin;
// 	btVector3 localAabbMax;

// 	localAabbMin[m_coneIndices[0]] = -m_radius1;
// 	localAabbMin[m_coneIndices[1]] = -m_height/2;
// 	localAabbMin[m_coneIndices[2]] = -m_radius1;

// 	localAabbMax[m_coneIndices[0]] = m_radius1;
// 	localAabbMax[m_coneIndices[1]] = m_height/2;
// 	localAabbMax[m_coneIndices[2]] = m_radius1;

// 	btTransformAabb(localAabbMin,localAabbMax, getMargin(),t,aabbMin,aabbMax);
// }

void btTruncatedConeShape::getAabb(const btTransform& t,btVector3& aabbMin,btVector3& aabbMax) const
{
	btTransformAabb(getHalfExtentsWithoutMargin(),getMargin(),t,aabbMin,aabbMax);
}

void btTruncatedConeShape::calculateLocalInertia(btScalar mass,btVector3& inertia) const
{

	
	
	// btScalar h_ext = a*h/(a-b);
	// btScalar h_tip = h_ext - h;

	// const btScalar Ixy = mass * 3/80. * (h_ext*h_ext + 4.* a*a - h_tip*h_tip - 4. * b*b);
	// const btScalar Izz = mass * 3/10. * (a*a - b*b);

	// btScalar w = (a+b)/2.;
	// const btScalar Ixy = mass / 12. * (4*w*w + h*h);
	// const btScalar Izz = mass / 12. * (4*w*w + 4*w*w);

	// APPROXIMATIOIN WITH CYLINDER OF AVERAGE RADIUS
	btScalar w = (m_radius1+m_radius2)/2.f;
	btScalar h = m_height;
	btScalar div12 = mass / 12.f;
	btScalar div4 = mass / 4.f;
	btScalar div2 = mass / 2.f;

	btScalar h2 = h*h;
	btScalar w2 = w*w;
	const btScalar Ixy = div12 * h2 + div4 * w2;
	const btScalar Izz = div2 * w2;

	inertia[m_coneIndices[0]] = Ixy;
	inertia[m_coneIndices[1]] = Izz;
	inertia[m_coneIndices[2]] = Ixy;

	// btScalar margin = getMargin();

	// btTransform ident;
	// ident.setIdentity();
	// btVector3 aabbMin,aabbMax;
	// getAabb(ident,aabbMin,aabbMax);
	// btVector3 halfExtents = (aabbMax-aabbMin)*btScalar(0.5);

	// btScalar lx=btScalar(2.)*(halfExtents.x()+margin);
	// btScalar ly=btScalar(2.)*(halfExtents.y()+margin);
	// btScalar lz=btScalar(2.)*(halfExtents.z()+margin);
	// const btScalar x2 = lx*lx;
	// const btScalar y2 = ly*ly;
	// const btScalar z2 = lz*lz;
	// const btScalar scaledmass = mass * btScalar(0.08333333);

	// inertia = scaledmass * (btVector3(y2+z2,x2+z2,x2+y2));

	// const btScalar Ixy = mass / 20. * (7.*h_ext*h_ext + 3.* a*a - 7.*h_tip*h_tip - 3. * b*b);
	// const btScalar Izz = mass * 3/10. * (a*a - b*b);

	

}

///choose upAxis index
void	btTruncatedConeShape::setConeUpIndex(int upIndex)
{
	switch (upIndex)
	{
	case 0:
			m_coneIndices[0] = 1;
			m_coneIndices[1] = 0;
			m_coneIndices[2] = 2;
		break;
	case 1:
			m_coneIndices[0] = 0;
			m_coneIndices[1] = 1;
			m_coneIndices[2] = 2;
		break;
	case 2:
			m_coneIndices[0] = 0;
			m_coneIndices[1] = 2;
			m_coneIndices[2] = 1;
		break;
	default:
		btAssert(0);
	};
	
	m_implicitShapeDimensions[m_coneIndices[0]] = m_radius1;
	m_implicitShapeDimensions[m_coneIndices[1]] = m_height/2;
	m_implicitShapeDimensions[m_coneIndices[2]] = m_radius1;

}

btVector3 btTruncatedConeShape::coneLocalSupport(const btVector3& v) const
{

	//mapping depends on how cylinder local orientation is
	// extents of the cylinder is: X,Y is for radius, and Z for height


	btScalar radius1 = m_radius1;
	btScalar radius2 = m_radius2;
	btScalar height = m_height;

	btVector3 tmp;
	btScalar d ;

	btScalar s = btSqrt(v[m_coneIndices[0]] * v[m_coneIndices[0]] + v[m_coneIndices[2]] * v[m_coneIndices[2]]);
	if (s != btScalar(0.0))
	{	
		d = v[m_coneIndices[1]] < 0.0 ? (radius1/s) : (radius2/s);  
		tmp[m_coneIndices[0]] = v[m_coneIndices[0]] * d;
		tmp[m_coneIndices[1]] = v[m_coneIndices[1]] < 0.0 ? -height/2 : (height/2);
		tmp[m_coneIndices[2]] = v[m_coneIndices[2]] * d;
		return tmp;
	}
	else
	{
		tmp[m_coneIndices[0]] = v[m_coneIndices[1]] < 0.0 ? radius1 : radius2;
		tmp[m_coneIndices[1]] = v[m_coneIndices[1]] < 0.0 ? -height/2 : (height/2);
		tmp[m_coneIndices[2]] = btScalar(0.0);
		return tmp;

	}


}

btVector3	btTruncatedConeShape::localGetSupportingVertexWithoutMargin(const btVector3& vec) const
{
		return coneLocalSupport(vec);
}

void	btTruncatedConeShape::batchedUnitVectorGetSupportingVertexWithoutMargin(const btVector3* vectors,btVector3* supportVerticesOut,int numVectors) const
{
	for (int i=0;i<numVectors;i++)
	{
		const btVector3& vec = vectors[i];
		supportVerticesOut[i] = coneLocalSupport(vec);
	}
}


btVector3	btTruncatedConeShape::localGetSupportingVertex(const btVector3& vec)  const
{
	btVector3 supVertex = coneLocalSupport(vec);
	if ( getMargin()!=btScalar(0.) )
	{
		btVector3 vecnorm = vec;
		if (vecnorm .length2() < (SIMD_EPSILON*SIMD_EPSILON))
		{
			vecnorm.setValue(btScalar(-1.),btScalar(-1.),btScalar(-1.));
		} 
		vecnorm.normalize();
		supVertex+= getMargin() * vecnorm;
	}
	return supVertex;
}


void	btTruncatedConeShape::setLocalScaling(const btVector3& scaling)
{
	int axis = 2;
	int r1 = 0;
	int r2 = 1;
	m_height *= scaling[axis] / m_localScaling[axis];
	m_com *= scaling[axis] / m_localScaling[axis];
	m_radius1 *= (scaling[r1] / m_localScaling[r1] + scaling[r2] / m_localScaling[r2]) / 2;
  	m_radius2 *= (scaling[r1] / m_localScaling[r1] + scaling[r2] / m_localScaling[r2]) / 2;
	m_sinAngle = ((m_radius1-m_radius2) / btSqrt((m_radius1-m_radius2) * (m_radius1-m_radius2) + m_height * m_height));
	btConvexInternalShape::setLocalScaling(scaling);
}
