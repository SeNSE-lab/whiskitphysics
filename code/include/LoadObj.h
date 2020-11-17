/*
WHISKiT Physics Simulator
Copyright (C) 2019 Nadina Zweifel (SeNSE Lab)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef LOAD_OBJ_H
#define LOAD_OBJ_H


struct GLInstanceGraphicsShape;

#include <ThirdPartyLibs/Wavefront/tiny_obj_loader.h>
#include <btBulletDynamicsCommon.h>
#include <btBulletCollisionCommon.h>
#include <Importers/ImportURDFDemo/BulletUrdfImporter.h>
#include <BulletCollision/CollisionShapes/btConvexHullShape.h>


btCollisionShape* createConvexHullFromShapes(std::vector<tinyobj::shape_t>& shapes, const btVector3& geomScale);
btCollisionShape* LoadShapeFromObj(const char* relativeFileName, const char* materialPrefixPath, const btVector3& geomScale);

#endif //LOAD_OBJ_HPP

