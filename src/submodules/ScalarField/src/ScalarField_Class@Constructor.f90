! This program is a part of EASIFEM library
! Copyright (C) 2020-2021  Vikas Sharma, Ph.D
!
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <https: //www.gnu.org/licenses/>
!

SUBMODULE( ScalarField_Class ) Constructor
USE BaseMethod
IMPLICIT NONE
CONTAINS

!----------------------------------------------------------------------------
!                                                            setScalarField
!----------------------------------------------------------------------------

MODULE PROCEDURE setScalarFieldParam
  INTEGER( I4B ) :: ierr
  ierr = param%set( key="ScalarField/name", value=name )
  IF( PRESENT( fieldType ) ) THEN
    ierr = param%set( key="ScalarField/fieldType", value=fieldType )
  ELSE
    ierr = param%set( key="ScalarField/fieldType", value=FIELD_TYPE_NORMAL )
  END IF
END PROCEDURE setScalarFieldParam


!----------------------------------------------------------------------------
!
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_addSurrogate
  CALL e%addSurrogate(UserObj)
END PROCEDURE sField_addSurrogate

!----------------------------------------------------------------------------
!                                                        CheckEssentialParam
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_checkEssentialParam
  CHARACTER( LEN = * ), PARAMETER :: myName = "sField_checkEssentialParam"
  IF( .NOT. param%isPresent(key="ScalarField/name") ) THEN
    CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'names should be present in param')
  END IF
END PROCEDURE sField_checkEssentialParam

!----------------------------------------------------------------------------
!                                                                   Initiate
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_Initiate1
  CHARACTER( LEN = * ), PARAMETER :: myName="sField_Initiate"
  INTEGER( I4B ) :: ierr, storageFMT
  INTEGER( I4B ) :: tNodes( 1 ), spaceCompo( 1 ), timeCompo( 1 )
  CHARACTER( LEN=: ), ALLOCATABLE :: char_var
  CHARACTER( LEN=1 ) :: names_char( 1 )

  !> main program
  IF( obj%isInitiated ) &
    & CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'Scalar object is already initiated')
  !> check
  CALL obj%checkEssentialParam(param)
  !> READ name
  ALLOCATE( CHARACTER( LEN = param%DataSizeInBytes( key="ScalarField/name" ) ) :: char_var )
  ierr = param%get( key="ScalarField/name", value=char_var )
  obj%name = char_var
  names_char( 1 )(1:1) = char_var( 1:1 )
  !> READ fieldType
  IF( param%isPresent(key="ScalarField/fieldType") ) THEN
    ierr = param%get( key="ScalarField/fieldType", value=obj%fieldType )
  ELSE
    obj%fieldType = FIELD_TYPE_NORMAL
  END IF
  !> SET engine
  obj%engine="NATIVE_SERIAL"
  !
  spaceCompo = [1]
  timeCompo = [1]
  storageFMT = FMT_NODES
  obj%domain => dom
  IF( obj%fieldType .EQ. FIELD_TYPE_CONSTANT ) THEN
    tNodes = 1
    obj%tSize = obj%domain%getTotalNodes()
  ELSE
    tNodes = obj%domain%getTotalNodes()
    obj%tSize = tNodes( 1 )
  END IF
  !
  CALL initiate( obj=obj%dof, tNodes=tNodes, names=names_char, &
    & spaceCompo=spaceCompo, timeCompo=timeCompo, storageFMT=storageFMT )
  !>
  CALL initiate( obj%realVec, obj%dof )
  !>
  obj%isInitiated = .TRUE.
  !>
  IF( ALLOCATED( char_var ) ) DEALLOCATE( char_var )
END PROCEDURE sField_Initiate1

!----------------------------------------------------------------------------
!                                                                 Initiate
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_Initiate2
  CHARACTER( LEN = * ), PARAMETER :: myName="sField_Initiate2"
  IF( .NOT. obj2%isInitiated ) &
    & CALL e%raiseError(modName//'::'//myName// " - "// &
    & 'Obj2 is not initiated!')
  obj%isInitiated = .TRUE.
  obj%fieldType = obj2%fieldType
  obj%domain => obj2%domain
  obj%name = obj2%name
  obj%engine = obj2%engine
  SELECT TYPE ( obj2 )
  TYPE IS ( ScalarField_ )
    obj%tSize = obj2%tSize
    obj%realVec = obj2%realVec
    obj%dof = obj2%dof
  END SELECT
END PROCEDURE sField_Initiate2

!----------------------------------------------------------------------------
!                                                             DeallocateData
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_DeallocateData
  CHARACTER( LEN = * ), PARAMETER :: myName="sField_DeallocateData"
  obj%tSize = 0_I4B
  obj%isInitiated = .FALSE.
  obj%fieldType = FIELD_TYPE_CONSTANT
  CALL DeallocateData( obj%realvec )
  CALL DeallocateData( obj%dof )
  NULLIFY( obj%domain )
END PROCEDURE sField_DeallocateData

!----------------------------------------------------------------------------
!                                                                     Final
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_Final
  CALL obj%DeallocateData()
END PROCEDURE sField_Final

!----------------------------------------------------------------------------
!                                                                ScalarField
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_Constructor1
  CALL ans%initiate( param, dom )
END PROCEDURE sField_Constructor1

!----------------------------------------------------------------------------
!                                                         ScalarField_Pointer
!----------------------------------------------------------------------------

MODULE PROCEDURE sField_Constructor_1
  ALLOCATE( ans )
  CALL ans%initiate( param, dom )
END PROCEDURE sField_Constructor_1

!----------------------------------------------------------------------------
!
!----------------------------------------------------------------------------

END SUBMODULE Constructor