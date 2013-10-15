//
//  BUPublicacionesInactivasVC.m
//  BrockUs
//
//  Created by Nodus12 on 11/10/13.
//  Copyright (c) 2013 Nodus. All rights reserved.
//

#import "BUPublicacionesInactivasVC.h"
#import "BUAppDelegate.h"
#import "Publicacion.h"
#import "BUConsultaDetallePubVC.h"
#import "BUConsultaPublicacion.h"

@interface BUPublicacionesInactivasVC (){
    NSManagedObjectContext *context;
    NSMutableArray *fetchedArray;
    
}
@property (strong) Persona *userbrockus;

@end

@implementation BUPublicacionesInactivasVC
@synthesize pub;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    BUConsultaPublicacion *cons=[[BUConsultaPublicacion alloc] init];
    NSString *userStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserBrockus"];
    self.userbrockus = [cons recuperaPersona:userStr :context];
    
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *consulta = [NSEntityDescription
                                     entityForName:@"Publicacion" inManagedObjectContext:context];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"toPersona= %@ AND status=0",self.userbrockus];
    NSLog(@"Usuario de consulta: %@",self.userbrockus);
    [request setPredicate:predicate];
    
    
    [request setEntity:consulta];
    
    fetchedArray = [[context executeFetchRequest:request error:&error]mutableCopy];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    return [fetchedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    // Configure the cell...
    pub=[fetchedArray objectAtIndex:indexPath.row];
    NSString *publicacion=pub.titulo;
    cell.textLabel.text = publicacion;

    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if ([fetchedArray count] >= 1) {
            [tableView beginUpdates];
            pub=[fetchedArray objectAtIndex:indexPath.row];
            pub.status=[[NSNumber alloc] initWithInt:1] ;
            NSLog(@"PUBLICACION: %@",pub);
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [fetchedArray removeObjectAtIndex:[indexPath row]];
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Error al actualizar los datos: %@ %@", error, [error localizedDescription]);
            }
            
            /*if ([fetchedArray count] == 0) {
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }*/
            [tableView endUpdates];
        }
    }
    
}
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Reactivar";
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

-(void)reloadTable{
    BUAppDelegate * buappdelegate=[[UIApplication sharedApplication]delegate];
    context =[buappdelegate managedObjectContext];
    
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *consulta = [NSEntityDescription
                                     entityForName:@"Publicacion" inManagedObjectContext:context];
    
    
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@" status=0"];
    [request setPredicate:predicate];
    
    [request setEntity:consulta];
    
    fetchedArray = [[context executeFetchRequest:request error:&error]mutableCopy];
    [self.tableView reloadData];
    
}

@end

