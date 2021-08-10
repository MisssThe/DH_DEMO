UE = CS.UnityEngine


function Update()
    x = UE.Input.GetAxis("Mouse X")
    y = UE.Input.GetAxis("Mouse Y")
    obj = UE.GameObject.Find("Cube")
    obj_transform = obj.transform
    mine_transform = self.transform
    mine_transform:RotateAround(obj_transform.position,obj_transform.up,x * 150 * UE.Time.deltaTime)
    mine_transform:RotateAround(obj_transform.position,mine_transform.right,-y * 150 * UE.Time.deltaTime)
end