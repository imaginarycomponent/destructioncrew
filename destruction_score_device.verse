
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
destruction_score_device := class(creative_device):

    @editable ScoreDevice : score_manager_device := score_manager_device{}
    @editable ReduceScoreDevice : score_manager_device := score_manager_device{}
    @editable PropManipulatorDeviceArray : []prop_manipulator_device := array{}
    @editable PropManipulatorDeviceArrayPreserve : []prop_manipulator_device := array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        for(CurrentElement : PropManipulatorDeviceArray):
            spawn{SubscribeToPropDestroy(CurrentElement)}

        for(CurrentElement : PropManipulatorDeviceArrayPreserve):
            CurrentElement.DestroyedEvent.Subscribe(ProcessBadDestroyProp)
    
    ProcessDestroyProp(AgentIn : agent):void= 
        ScoreDevice.Activate(AgentIn)

    ProcessBadDestroyProp(AgentIn : agent):void= 
        ReduceScoreDevice.Activate(AgentIn)

    SubscribeToPropDestroy(Manipulator_In : prop_manipulator_device)<suspends>:void=
        Manipulator_In.DestroyedEvent.Subscribe(ProcessDestroyProp)

    ResetAll(): void=
        for(CurrentElement : PropManipulatorDeviceArray):
            CurrentElement.RestoreHealth()