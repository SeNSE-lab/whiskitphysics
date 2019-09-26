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

#ifndef BT_TRUNCATED_CONE_MINKOWSKI_H
#define BT_TRUNCATED_CONE_MINKOWSKI_H

#include "btConvexInternalShape.h"
#include "BulletCollision/BroadphaseCollision/btBroadphaseProxy.h" // for the types
#include "LinearMath/btVector3.h"

///The btTruncatedConeShape implements a cone shape primitive, centered around the origin and aligned with the Y axis. The btTruncatedConeShapeX is aligned around the X axis and btTruncatedConeShapeZ around the Z axis.
ATTRIBUTE_ALIGNED16(class) btTruncatedConeShape : public btConvexInternalShape

{
	btScalar m_axis;
	btScalar m_sinAngle;
	btScalar m_radius1;
    btScalar m_radius2;
	btScalar m_height;
	btScalar m_halfExtent;
    btScalar m_com;
	int		m_coneIndices[3];
	btVector3 coneLocalSupport(const btVector3& v) const;


public:
	BT_DECLARE_ALIGNED_ALLOCATOR();
	
	
	btTruncatedConeShape (btScalar radius1,btScalar radius2,btScalar height, btScalar axis);
	
	btVector3 getHalfExtentsWithMargin() const
	{
		btVector3 halfExtents = getHalfExtentsWithoutMargin();
		btVector3 margin(getMargin(),getMargin(),getMargin());
		halfExtents += margin;
		return halfExtents;
	}
	
	const btVector3& getHalfExtentsWithoutMargin() const
	{
		return m_implicitShapeDimensions;//scaling is included, margin is not
	}
	
	virtual btVector3	localGetSupportingVertex(const btVector3& vec) const;
	virtual btVector3	localGetSupportingVertexWithoutMargin(const btVector3& vec) const;
	virtual void	batchedUnitVectorGetSupportingVertexWithoutMargin(const btVector3* vectors,btVector3* supportVerticesOut,int numVectors) const;

	btScalar getRadius1() const { return m_radius1;}
    btScalar getRadius2() const { return m_radius2;}
	btScalar getHeight() const { return m_height;}
    btScalar getCenterOfMass() const { return m_com;}
	
	void setRadius1(const btScalar radius)
	{
		m_radius1 = radius;
	}

    void setRadius2(const btScalar radius)
	{
		m_radius2 = radius;
	}

	void setHeight(const btScalar height)
	{
		m_height = height;
		m_halfExtent = height/2.;
		m_com = (height)/4*(pow(m_radius1,2) + 2*m_radius1*m_radius2 + 3*pow(m_radius2,2))/(pow(m_radius1,2) + m_radius1*m_radius2 + pow(m_radius2,2));
	}
    

	void getAabb(const btTransform& t,btVector3& aabbMin,btVector3& aabbMax) const;
	virtual void	calculateLocalInertia(btScalar mass,btVector3& inertia) const;


	virtual const char*	getName()const
	{	
		switch(m_coneIndices[1]){
		
			case 0:
				return "TruncatedConeX";
				break;
			case 1:
				return "TruncatedConeY";
				break;
			case 2:
				return "TruncatedConeZ";
				break;
			default:
				btAssert(0);
			};
	}
	
	///choose upAxis index
	void	setConeUpIndex(int upIndex);
	
	int	getConeUpIndex() const
	{
		return m_coneIndices[1];
	}

	virtual btVector3	getAnisotropicRollingFrictionDirection() const
	{	
		btVector3 aniDir(0,0,0);
		aniDir[getConeUpIndex()]=1;
		return aniDir;
	}

	virtual void setMargin(btScalar collisionMargin)
	{
		//correct the m_implicitShapeDimensions for the margin
		btVector3 oldMargin(getMargin(),getMargin(),getMargin());
		btVector3 implicitShapeDimensionsWithMargin = m_implicitShapeDimensions+oldMargin;
		
		btConvexInternalShape::setMargin(collisionMargin);
		btVector3 newMargin(getMargin(),getMargin(),getMargin());
		m_implicitShapeDimensions = implicitShapeDimensionsWithMargin - newMargin;

	}

	virtual void	setLocalScaling(const btVector3& scaling);
	
	
	virtual	int	calculateSerializeBufferSize() const;
	
	///fills the dataBuffer and returns the struct name (and 0 on failure)
	virtual	const char*	serialize(void* dataBuffer, btSerializer* serializer) const;
	

};



///do not change those serialization structures, it requires an updated sBulletDNAstr/sBulletDNAstr64
struct	btTruncatedConeShapeData
{
	btConvexInternalShapeData	m_convexInternalShapeData;
	
	int	m_upIndex;
	
	char	m_padding[4];
};

SIMD_FORCE_INLINE	int	btTruncatedConeShape::calculateSerializeBufferSize() const
{
	return sizeof(btTruncatedConeShapeData);
}

///fills the dataBuffer and returns the struct name (and 0 on failure)
SIMD_FORCE_INLINE	const char*	btTruncatedConeShape::serialize(void* dataBuffer, btSerializer* serializer) const
{
	btTruncatedConeShapeData* shapeData = (btTruncatedConeShapeData*) dataBuffer;

	btConvexInternalShape::serialize(&shapeData->m_convexInternalShapeData,serializer);

	shapeData->m_upIndex = m_coneIndices[1];

	// Fill padding with zeros to appease msan.
	shapeData->m_padding[0] = 0;
	shapeData->m_padding[1] = 0;
	shapeData->m_padding[2] = 0;
	shapeData->m_padding[3] = 0;

	return "btTruncatedConeShapeData";
}

#endif //BT_CONE_MINKOWSKI_H

